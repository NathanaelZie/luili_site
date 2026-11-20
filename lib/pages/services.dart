import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../components/icons.dart';
import '../components/sections.dart';
import '../data/site_data.dart';
import 'not_found.dart';

class ServicesPage extends StatelessComponent {
  const ServicesPage({super.key});

  @override
  Component build(BuildContext context) {
    return div([
      seo(title: 'Nos services', description: 'Construction neuve, rénovation, gros œuvre, VRD, études et finitions : découvrez les métiers de ${Company.name}.'),
      pageHero(
        title: 'Nos services',
        subtitle: 'Tous les corps d\'état du bâtiment et des travaux publics, coordonnés par une seule équipe.',
        breadcrumbs: const [(label: 'Accueil', href: '/'), (label: 'Services', href: null)],
      ),
      section(classes: 'bg:stone py:[5rem]', [
        container([
          div(classes: 'grid gap:6 md:cols:2 lg:cols:3', [for (final (i, s) in services.indexed) serviceCard(s, index: i % 3)]),
        ]),
      ]),
      section(classes: 'bg:white py:[5rem]', [
        container(classes: 'mw:[52rem]!', [
          sectionHeading(eyebrow: 'Questions fréquentes', title: 'Vous vous demandez peut-être…', center: true),
          JxAccordion(
            [
              for (final f in faqs) JxAccordionItem(title: f.q, children: [p(classes: 'c:gray-500 lh:relaxed', [.text(f.a)])]),
            ],
            name: 'faq',
            exclusive: true,
          ),
        ]),
      ]),
      ctaBand(),
    ]);
  }
}

class ServiceDetailPage extends StatelessComponent {
  const ServiceDetailPage({required this.slug, super.key});

  final String slug;

  @override
  Component build(BuildContext context) {
    final s = serviceBySlug(slug);
    if (s == null) return const NotFoundPage();

    return div([
      seo(title: s.title, description: s.summary),
      pageHero(
        title: s.title,
        subtitle: s.summary,
        image: s.image,
        breadcrumbs: [(label: 'Accueil', href: '/'), (label: 'Services', href: '/services'), (label: s.title, href: null)],
      ),
      section(classes: 'bg:white py:[5rem]', [
        container(classes: 'grid gap:12 lg:cols:3', [
          div(classes: 'lg:span:2 flex fd:column gap:10', [
            div([
              h2(classes: 'fs:2xl fw:extrabold c:ink', [.text('Ce que nous faisons')]),
              p(classes: 'mt:4 fs:lg c:gray-700 lh:relaxed', [.text(s.intro)]),
            ]),
            tickList(s.points, classes: 'sm:grid sm:cols:2'),
            div([
              h2(classes: 'fs:2xl fw:extrabold c:ink mb:6', [.text('Comment nous travaillons')]),
              ol(classes: 'grid gap:4 sm:cols:2', [
                for (final (i, step) in s.steps.indexed)
                  li(classes: 'flex ai:center gap:4 p:5 br:lg bg:stone', attributes: reveal(index: i), [
                    span(classes: 'w:10 h:10 br:full bg:brand c:white fw:bold flex ai:center jc:center shrink:0', [.text('${i + 1}')]),
                    span(classes: 'fw:medium c:ink', [.text(step)]),
                  ]),
              ]),
            ]),
          ]),
          aside(classes: 'flex fd:column gap:6', attributes: reveal(anim: Reveal.fade, index: 2), [
            JxCard(
              title: 'Un projet de ce type ?',
              description: 'Visite et devis détaillé gratuits, sans engagement.',
              classes: 'bg:brandl! bc:brandl!',
              [
                JxButton([.text('Demander un devis')], href: '/contact?service=${s.slug}', fullWidth: true, classes: 'bg:brand! hover:bg:brandd!'),
                a(href: Company.phoneHref, classes: 'mt:2 inline-flex ai:center jc:center gap:2 w:full c:ink fw:semibold hover:c:brand', [
                  icon('phone', classes: 'w:4 h:4 c:brand'),
                  .text(Company.phone),
                ]),
              ],
            ),
            nav(classes: 'br:xl bw:1 bc:gray-100 p:6', attributes: {'aria-label': 'Autres services'}, [
              h2(classes: 'fw:bold c:ink mb:3', [.text('Autres services')]),
              ul(classes: 'flex fd:column gap:1', [
                for (final other in services)
                  if (other.slug != s.slug)
                    li([
                      a(href: '/services/${other.slug}', classes: 'flex ai:center jc:between px:3 py:2 br:md c:gray-700 hover:bg:stone hover:c:brand', [
                        .text(other.title),
                        icon('arrow', classes: 'w:4 h:4'),
                      ]),
                    ]),
              ]),
            ]),
          ]),
        ]),
      ]),
      ctaBand(),
    ]);
  }
}
