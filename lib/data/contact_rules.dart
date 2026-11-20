/// Règles du formulaire de contact, partagées par la page (attributs HTML)
/// et par le serveur (validation réelle, la seule qui fait foi).
library;

import 'site_data.dart';

abstract final class ContactRules {
  static const nameMax = 100;
  static const emailMax = 254;
  static const phoneMax = 30;
  static const messageMin = 10;
  static const messageMax = 5000;

  /// Taille maximale du corps de la requête, en octets.
  static const maxBodyBytes = 16 * 1024;

  /// Champ piège invisible : un humain le laisse vide, un robot le remplit.
  static const honeypotField = 'site_internet';

  static const otherSubject = 'autre';

  static List<({String value, String label})> get subjects => [
    for (final s in services) (value: s.slug, label: s.title),
    (value: otherSubject, label: 'Autre demande'),
  ];

  static bool isValidSubject(String value) => subjects.any((s) => s.value == value);
}
