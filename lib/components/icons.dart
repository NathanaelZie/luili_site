import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Tracés SVG (24×24, trait) des icônes du site.
///
/// Ce sont des constantes du code : jamais de données utilisateur ici,
/// puisqu'elles sont insérées telles quelles dans le HTML.
const Map<String, String> _paths = {
  'building': '<path d="M3 21h18"/><path d="M5 21V7l7-4 7 4v14"/><path d="M9 9h1M14 9h1M9 13h1M14 13h1M9 17h1M14 17h1"/>',
  'hammer': '<path d="m15 12-8.4 8.4a2 2 0 0 1-2.8-2.8L12.2 9"/><path d="M17.6 6.4 20 8.8l-3.5 3.5-5.3-5.3 3.5-3.5 2.4 2.4"/>',
  'layers': '<path d="m12 3 9 5-9 5-9-5 9-5Z"/><path d="m3 13 9 5 9-5"/>',
  'road': '<path d="M5 21 9 3M19 21 15 3"/><path d="M12 5v2M12 11v2M12 17v2"/>',
  'ruler': '<path d="M3 17 17 3l4 4L7 21l-4-4Z"/><path d="m7 13 2 2M10 10l2 2M13 7l2 2"/>',
  'paint': '<rect x="4" y="3" width="14" height="6" rx="1"/><path d="M18 6h2v5h-8v3"/><path d="M11 14h2v7h-2z"/>',
  'shield': '<path d="M12 3 4 6v6c0 5 3.5 8 8 9 4.5-1 8-4 8-9V6l-8-3Z"/><path d="m9 12 2 2 4-4"/>',
  'clock': '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
  'check': '<circle cx="12" cy="12" r="9"/><path d="m8 12 3 3 5-6"/>',
  'file': '<path d="M14 3H6v18h12V7l-4-4Z"/><path d="M14 3v4h4M9 13h6M9 17h6"/>',
  'phone': '<path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2"/>',
  'mail': '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/>',
  'pin': '<path d="M12 21s-7-6.1-7-12a7 7 0 0 1 14 0c0 5.9-7 12-7 12Z"/><circle cx="12" cy="9" r="2.5"/>',
  'arrow': '<path d="M5 12h14M13 6l6 6-6 6"/>',
  'menu': '<path d="M4 7h16M4 12h16M4 17h16"/>',
  'calendar': '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4"/>',
  'tick': '<path d="m5 12 5 5L20 7"/>',
};

/// Icône décorative (masquée aux lecteurs d'écran).
Component icon(String name, {String classes = 'w:5 h:5'}) {
  final path = _paths[name] ?? _paths['check']!;
  return span(
    classes: 'inline-flex shrink:0 $classes',
    attributes: const {'aria-hidden': 'true'},
    [
      RawText(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="100%" height="100%" fill="none" '
        'stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">$path</svg>',
      ),
    ],
  );
}
