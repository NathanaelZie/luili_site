import 'dart:io';

import 'package:shelf/shelf.dart';

/// Ajoute les en-têtes de sécurité et de cache à toutes les réponses.
///
/// La CSP n'autorise que les ressources du site lui-même : pas de script
/// tiers, pas d'iframe, formulaires envoyés uniquement vers le site.
Middleware securityHeaders({required bool production}) {
  // En développement, le rechargement à chaud de Jaspr exécute un script inline.
  final scriptSrc = production ? "script-src 'self'; " : "script-src 'self' 'unsafe-inline' 'unsafe-eval'; ";
  final csp = "default-src 'self'; "
      "$scriptSrc"
      // Jaspr insère les styles @css dans une balise <style> de la page.
      "style-src 'self' 'unsafe-inline'; "
      "img-src 'self' data:; "
      "font-src 'self'; "
      "connect-src 'self'; "
      "object-src 'none'; "
      "base-uri 'self'; "
      "form-action 'self'; "
      "frame-ancestors 'none'";

  return (Handler inner) {
    return (Request request) async {
      final response = await inner(request);
      final path = request.url.path;
      return response.change(headers: {
        'content-security-policy': production ? '$csp; upgrade-insecure-requests' : csp,
        'x-content-type-options': 'nosniff',
        'x-frame-options': 'DENY',
        'referrer-policy': 'strict-origin-when-cross-origin',
        'permissions-policy': 'camera=(), microphone=(), geolocation=(), payment=(), usb=()',
        'cross-origin-opener-policy': 'same-origin',
        'cross-origin-resource-policy': 'same-origin',
        if (production) 'strict-transport-security': 'max-age=31536000; includeSubDomains',
        if (!response.headers.containsKey('cache-control')) 'cache-control': _cacheControl(path, production),
      });
    };
  };
}

String _cacheControl(String path, bool production) {
  if (!production) return 'no-store';
  final isAsset = RegExp(r'\.(css|js|jpe?g|png|webp|avif|svg|ico|woff2?)$').hasMatch(path);
  // Les pages restent fraîches ; les fichiers statiques sont mis en cache une semaine.
  return isAsset ? 'public, max-age=604800' : 'no-cache';
}

/// Refuse les méthodes HTTP inutiles pour un site vitrine.
Middleware allowedMethods() {
  const allowed = {'GET', 'HEAD', 'POST'};
  return (Handler inner) {
    return (Request request) {
      if (!allowed.contains(request.method)) {
        return Response(HttpStatus.methodNotAllowed, headers: {'allow': allowed.join(', ')});
      }
      return inner(request);
    };
  };
}

/// Adresse IP du client, en tenant compte du reverse proxy si [trustProxy].
String clientIp(Request request, {required bool trustProxy}) {
  if (trustProxy) {
    final forwarded = request.headers['x-forwarded-for'];
    if (forwarded != null && forwarded.trim().isNotEmpty) {
      return forwarded.split(',').first.trim();
    }
  }
  final info = request.context['shelf.io.connection_info'];
  if (info is HttpConnectionInfo) return info.remoteAddress.address;
  return 'inconnue';
}

/// Vérifie qu'un POST vient bien d'une page du site (protection CSRF).
bool isSameOrigin(Request request, {required bool trustProxy}) {
  final host = (trustProxy ? request.headers['x-forwarded-host'] : null) ?? request.headers['host'];
  if (host == null) return false;
  final origin = request.headers['origin'] ?? request.headers['referer'];
  // Certains navigateurs n'envoient ni Origin ni Referer : on accepte, car le
  // formulaire n'agit sur aucun compte et reste limité en débit.
  if (origin == null) return true;
  final uri = Uri.tryParse(origin);
  if (uri == null || uri.host.isEmpty) return false;
  final authority = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
  return authority == host.toLowerCase();
}
