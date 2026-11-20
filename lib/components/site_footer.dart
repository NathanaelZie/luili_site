import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import 'icons.dart';
import 'sections.dart';

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    final year = DateTime.now().year;
    return footer(classes: 'bg:ink c:gray-300 fs:sm', [
      div(classes: 'mw:[76rem] mx:auto px:6 py:16 grid gap:10 md:cols:2 lg:cols:4', [
        div(classes: 'flex fd:column gap:4', [
          span(classes: 'flex fd:column lh:tight', [
            span(classes: 'fw:extrabold fs:xl c:white uppercase ls:[0.04em]', [.text('Luili')]),
            span(classes: 'fs:xs fw:semibold c:brand uppercase ls:[0.2em]', [.text('Construction')]),
          ]),
          p(classes: 'lh:relaxed', [.text(Company.description)]),
        ]),
        _column('Nos services', [
          for (final s in services) _link('/services/${s.slug}', s.title),
        ]),
        _column('Entreprise', [
          for (final item in mainNav.skip(1)) _link(item.path, item.label),
          _link('/mentions-legales', 'Mentions légales'),
        ]),
        _column('Contact', [
          _contactLine('pin', .text(Company.address)),
          _contactLine('phone', a(href: Company.phoneHref, classes: 'hover:c:white', [.text(Company.phone)])),
          _contactLine('mail', a(href: 'mailto:${Company.email}', classes: 'hover:c:white', [.text(Company.email)])),
          _contactLine('clock', .text(Company.hours)),
        ]),
      ]),
      div(classes: 'bwt:1 bc:inkl', [
        div(classes: 'mw:[76rem] mx:auto px:6 py:5 flex fd:column md:fd:row gap:2 jc:between c:gray-500 fs:xs', [
          span([.text('© $year ${Company.name}. Tous droits réservés.')]),
          span([.text(Company.tagline)]),
        ]),
        container(classes: 'pb:5 fs:xs c:gray-500', [
          p([
            .text("Photos d'illustration : Freepik — "),
            for (final (i, c) in photoCredits.indexed) ...[
              if (i > 0) .text(', '),
              a(href: c.url, classes: 'td:underline hover:c:white', attributes: {'rel': 'noopener nofollow', 'target': '_blank'}, [.text(c.author)]),
            ],
            .text('.'),
          ]),
        ]),
      ]),
    ]);
  }

  Component _column(String title, List<Component> children) {
    return div(classes: 'flex fd:column gap:3', [
      h2(classes: 'c:white fw:semibold fs:base mb:1', [.text(title)]),
      ul(classes: 'flex fd:column gap:2', [for (final c in children) li([c])]),
    ]);
  }

  Component _link(String href, String label) => a(href: href, classes: 'hover:c:brand tr:all dur:150', [.text(label)]);

  Component _contactLine(String iconName, Component child) {
    return span(classes: 'flex ai:start gap:2', [
      icon(iconName, classes: 'w:4 h:4 mt:[3px] c:brand'),
      span([child]),
    ]);
  }
}
