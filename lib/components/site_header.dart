import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../data/site_data.dart';
import 'icons.dart';

/// En-tête du site : barre d'informations, logo, menu et bouton devis.
///
/// Le menu mobile repose sur `<details>` : il fonctionne sans JavaScript.
class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) {
    final current = _section(context.url);

    return header(classes: 'sticky top:0 z:50 bg:white sh:sm', [
      // Barre d'informations (écrans moyens et plus).
      div(classes: 'd:none md:block bg:ink c:gray-300 fs:sm', [
        div(classes: 'mw:[76rem] mx:auto px:6 py:2 flex ai:center jc:between gap:6', [
          span(classes: 'inline-flex ai:center gap:2', [icon('clock', classes: 'w:4 h:4 c:brand'), .text(Company.hours)]),
          div(classes: 'flex ai:center gap:6', [
            a(href: Company.phoneHref, classes: 'inline-flex ai:center gap:2 hover:c:white', [
              icon('phone', classes: 'w:4 h:4 c:brand'),
              .text(Company.phone),
            ]),
            a(href: 'mailto:${Company.email}', classes: 'inline-flex ai:center gap:2 hover:c:white', [
              icon('mail', classes: 'w:4 h:4 c:brand'),
              .text(Company.email),
            ]),
          ]),
        ]),
      ]),

      div(classes: 'mw:[76rem] mx:auto px:6 py:3 flex ai:center jc:between gap:4', [
        a(href: '/', classes: 'flex ai:center gap:3', attributes: {'aria-label': '${Company.name}, accueil'}, [
          img(
            src: '/images/logo.jpeg',
            alt: '',
            width: 48,
            height: 48,
            classes: 'w:12 h:12 br:lg obf:cover',
          ),
          span(classes: 'flex fd:column lh:tight', [
            span(classes: 'fw:extrabold fs:lg c:ink uppercase ls:[0.04em]', [.text('Luili')]),
            span(classes: 'fs:xs fw:semibold c:brand uppercase ls:[0.2em]', [.text('Construction')]),
          ]),
        ]),

        // Navigation principale (ordinateur).
        nav(classes: 'd:none lg:flex ai:center gap:1', attributes: {'aria-label': 'Navigation principale'}, [
          for (final item in mainNav)
            a(
              href: item.path,
              attributes: {if (item.path == current) 'aria-current': 'page'},
              classes: item.path == current
                  ? 'px:4 py:2 br:md fs:sm fw:semibold c:brand bg:brandl'
                  : 'px:4 py:2 br:md fs:sm fw:medium c:gray-700 hover:c:brand hover:bg:stone tr:all dur:150',
              [.text(item.label)],
            ),
        ]),

        div(classes: 'flex ai:center gap:2', [
          JxButton(
            [.text('Devis gratuit')],
            href: '/contact',
            classes: 'd:none sm:inline-flex bg:brand! hover:bg:brandd!',
          ),

          // Menu mobile.
          Component.element(
            tag: 'details',
            classes: 'lg:d:none group',
            children: [
              Component.element(
                tag: 'summary',
                classes: 'lst:none cur:pointer p:2 br:md c:ink hover:bg:stone',
                attributes: {'aria-label': 'Ouvrir le menu'},
                children: [icon('menu', classes: 'w:6 h:6')],
              ),
              nav(
                classes: 'pos:absolute left:0 right:0 top:full bg:white sh:lg bwt:1 bc:gray-100 px:6 py:4 flex fd:column gap:1',
                attributes: {'aria-label': 'Navigation mobile'},
                [
                  for (final item in mainNav)
                    a(
                      href: item.path,
                      attributes: {if (item.path == current) 'aria-current': 'page'},
                      classes: item.path == current
                          ? 'px:3 py:3 br:md fw:semibold c:brand bg:brandl'
                          : 'px:3 py:3 br:md fw:medium c:gray-700 hover:bg:stone',
                      [.text(item.label)],
                    ),
                  JxButton([.text('Demander un devis')], href: '/contact', fullWidth: true, classes: 'mt:3 bg:brand! hover:bg:brandd!'),
                ],
              ),
            ],
          ),
        ]),
      ]),
    ]);
  }

  /// Rattache une URL à l'entrée de menu correspondante (/services/x → /services).
  static String _section(String url) {
    final path = Uri.parse(url).path;
    if (path == '/' || path.isEmpty) return '/';
    for (final item in mainNav) {
      if (item.path != '/' && (path == item.path || path.startsWith('${item.path}/'))) return item.path;
    }
    return '';
  }
}
