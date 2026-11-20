import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/sections.dart';
import '../data/site_data.dart';

class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  @override
  Component build(BuildContext context) {
    return div([
      seo(title: 'À propos', description: 'Découvrez ${Company.name}, son histoire, ses valeurs et ses équipes.'),
      pageHero(
        title: 'À propos de nous',
        subtitle: 'Une entreprise de terrain, fondée par des bâtisseurs, au service de projets qui durent.',
        image: Photos.rebar,
        breadcrumbs: const [(label: 'Accueil', href: '/'), (label: 'À propos', href: null)],
      ),
      section(classes: 'bg:white py:[5rem]', [
        container(classes: 'grid gap:12 lg:cols:2 ai:center', [
          div([
            sectionHeading(eyebrow: 'Notre histoire', title: 'Depuis ${Company.foundedYear}, nous construisons la confiance'),
            div(classes: 'flex fd:column gap:4 c:gray-700 lh:relaxed mt:[-1.5rem]', [
              // À REMPLACER : l'histoire réelle de l'entreprise.
              p([
                .text('${Company.name} est née de la volonté de proposer un service de construction fiable, '
                    'transparent et à l\'écoute. D\'abord spécialisée dans le gros œuvre, l\'entreprise s\'est '
                    'progressivement entourée d\'ingénieurs, de techniciens et d\'artisans qualifiés.'),
              ]),
              p([
                .text('Aujourd\'hui, nous accompagnons particuliers, entreprises et collectivités sur des projets '
                    'de bâtiment et de travaux publics, en assurant nous-mêmes l\'étude, l\'exécution et le suivi.'),
              ]),
            ]),
            tickList(const ['Bureau d\'études intégré', 'Matériel et équipes propres', 'Conducteur de travaux dédié'], classes: 'mt:8'),
          ]),
          div(classes: 'grid cols:2 gap:4', [
            div(classes: 'ar:[3/4] br:xl ov:hidden sh:lg', attributes: reveal(anim: Reveal.zoom), [photo(Photos.engineer, alt: "Ingénieur de l'équipe sur un chantier")]),
            div(classes: 'ar:[3/4] br:xl ov:hidden sh:lg mt:12', attributes: reveal(anim: Reveal.zoom, index: 2), [photo(Photos.paving, alt: "Mise en œuvre d'un enrobé sur une voirie")]),
          ]),
        ]),
      ]),
      section(classes: 'bg:ink py:[4rem]', [
        container(classes: 'grid cols:2 lg:cols:4 gap:8', [
          for (final (i, f) in keyFigures.indexed)
            div(classes: 'ta:center', attributes: reveal(index: i), [
              p(classes: 'fs:5xl fw:extrabold c:brand', attributes: {'data-count': ''}, [.text(f.value)]),
              p(classes: 'mt:2 c:gray-300 fs:sm uppercase ls:[0.08em]', [.text(f.label)]),
            ]),
        ]),
      ]),
      section(classes: 'bg:stone py:[5rem]', [
        container([
          sectionHeading(eyebrow: 'Nos valeurs', title: 'Ce qui guide chacun de nos chantiers', center: true),
          div(classes: 'grid gap:6 md:cols:2 lg:cols:4', [
            for (final (i, c) in commitments.indexed)
              div(classes: 'br:xl bg:white p:8 sh:sm', attributes: reveal(index: i), [
                span(classes: 'w:12 h:12 br:lg bg:brandl c:brand flex ai:center jc:center', [icon(c.icon, classes: 'w:6 h:6')]),
                h3(classes: 'mt:5 fs:lg fw:bold c:ink', [.text(c.title)]),
                p(classes: 'mt:2 fs:sm c:gray-500 lh:relaxed', [.text(c.text)]),
              ]),
          ]),
        ]),
      ]),
      ctaBand(),
    ]);
  }
}
