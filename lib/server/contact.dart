import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../data/contact_rules.dart';
import 'rate_limiter.dart';
import 'security.dart';

/// Une demande de contact validée.
class ContactRequest {
  const ContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
    required this.receivedAt,
    required this.ip,
  });

  final String name;
  final String email;
  final String phone;
  final String subject;
  final String message;
  final DateTime receivedAt;
  final String ip;

  Map<String, Object> toJson() => {
    'recu_le': receivedAt.toUtc().toIso8601String(),
    'nom': name,
    'email': email,
    'telephone': phone,
    'sujet': subject,
    'message': message,
    'ip': ip,
  };
}

/// Destination des demandes. Aujourd'hui un fichier ; demain une base de
/// données, un e-mail ou un CRM, sans toucher au reste du code.
abstract interface class ContactStore {
  Future<void> save(ContactRequest request);
}

/// Ajoute chaque demande sur une ligne JSON dans `<dataDir>/contacts.jsonl`.
///
/// Les écritures sont mises en file pour ne jamais s'entremêler.
class JsonlContactStore implements ContactStore {
  JsonlContactStore(String dataDir) : _file = File('$dataDir${Platform.pathSeparator}contacts.jsonl');

  final File _file;
  Future<void> _queue = Future.value();

  @override
  Future<void> save(ContactRequest request) {
    final line = '${jsonEncode(request.toJson())}\n';
    final next = _queue.then((_) async {
      await _file.parent.create(recursive: true);
      await _file.writeAsString(line, mode: FileMode.append, flush: true);
    });
    _queue = next.catchError((_) {});
    return next;
  }
}

/// Résultat de la validation : la demande, ou `null` si invalide.
ContactRequest? validateContact(Map<String, String> fields, {required String ip, DateTime? now}) {
  final name = _clean(fields['nom']);
  final email = _clean(fields['email']).toLowerCase();
  final phone = _clean(fields['telephone']);
  final subject = _clean(fields['sujet']);
  final message = _clean(fields['message'], multiline: true);

  final valid =
      name.length >= 2 &&
      name.length <= ContactRules.nameMax &&
      email.length <= ContactRules.emailMax &&
      _emailPattern.hasMatch(email) &&
      phone.length <= ContactRules.phoneMax &&
      (phone.isEmpty || _phonePattern.hasMatch(phone)) &&
      ContactRules.isValidSubject(subject) &&
      message.length >= ContactRules.messageMin &&
      message.length <= ContactRules.messageMax;
  if (!valid) return null;

  return ContactRequest(
    name: name,
    email: email,
    phone: phone,
    subject: subject,
    message: message,
    receivedAt: now ?? DateTime.now(),
    ip: ip,
  );
}

final _emailPattern = RegExp(r'^[^\s@<>()",;:]+@[^\s@<>()",;:]+\.[a-z]{2,}$');
final _phonePattern = RegExp(r'^[0-9+().\s-]{6,}$');

/// Supprime les caractères de contrôle (sauf retours à la ligne si [multiline]) et les espaces superflus.
String _clean(String? value, {bool multiline = false}) {
  if (value == null) return '';
  final pattern = multiline ? RegExp(r'[\x00-\x09\x0B\x0C\x0E-\x1F\x7F]') : RegExp(r'[\x00-\x1F\x7F]');
  var out = value.replaceAll('\r\n', '\n').replaceAll(pattern, '');
  if (!multiline) out = out.replaceAll(RegExp(r'\s+'), ' ');
  return out.trim();
}

/// Traite le POST du formulaire puis redirige vers la page contact (motif
/// Post/Redirect/Get : un rafraîchissement ne renvoie pas le formulaire).
Handler contactHandler({required ContactStore store, required RateLimiter limiter, required bool trustProxy}) {
  Response back(String status) => Response(
    HttpStatus.seeOther,
    headers: {'location': '/contact?statut=$status#formulaire', 'cache-control': 'no-store'},
  );

  return (Request request) async {
    if (request.method != 'POST') {
      return Response(HttpStatus.methodNotAllowed, headers: {'allow': 'POST'});
    }
    if (!isSameOrigin(request, trustProxy: trustProxy)) {
      return Response.forbidden('Origine refusée.');
    }
    final type = request.mimeType;
    if (type != 'application/x-www-form-urlencoded') {
      return Response(HttpStatus.unsupportedMediaType);
    }
    final declared = request.contentLength;
    if (declared != null && declared > ContactRules.maxBodyBytes) {
      return Response(HttpStatus.requestEntityTooLarge);
    }

    final ip = clientIp(request, trustProxy: trustProxy);
    if (!limiter.hit(ip)) return back('limite');

    final String body;
    try {
      body = await _readLimited(request.read(), ContactRules.maxBodyBytes);
    } on _TooLarge {
      return Response(HttpStatus.requestEntityTooLarge);
    } on FormatException {
      return back('invalide');
    }

    final Map<String, String> fields;
    try {
      fields = Uri.splitQueryString(body);
    } on Object {
      // Encodage invalide (pourcentages ou UTF-8 malformés).
      return back('invalide');
    }

    // Robot détecté : on fait comme si tout allait bien, sans rien enregistrer.
    if ((fields[ContactRules.honeypotField] ?? '').isNotEmpty) return back('ok');

    final contact = validateContact(fields, ip: ip);
    if (contact == null) return back('invalide');

    try {
      await store.save(contact);
    } catch (e, st) {
      stderr.writeln('Échec d\'enregistrement d\'une demande de contact : $e\n$st');
      return back('erreur');
    }
    return back('ok');
  };
}

class _TooLarge implements Exception {}

Future<String> _readLimited(Stream<List<int>> stream, int max) async {
  final bytes = <int>[];
  await for (final chunk in stream) {
    bytes.addAll(chunk);
    if (bytes.length > max) throw _TooLarge();
  }
  return utf8.decode(bytes);
}
