import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../data/site_data.dart';
import 'icons.dart';

/// Titre et description de la page (balises <title> et <meta>).
Component seo({required String title, required String description}) {
  return Document.head(
    title: title == Company.name ? '${Company.name} — BTP, construction et rénovation' : '$title | ${Company.name}',
    meta: {
      'description': description,
      'og:title': title,
      'og:description': description,
      'og:type': 'website',
    },
  );
}

/// Délais d'apparition en cascade (index d'un élément dans une grille).
const List<String> _stagger = ['', 'adelay:100!', 'adelay:200!', 'adelay:300!', 'adelay:400!', 'adelay:500!'];

/// Apparition au défilement : web/reveal.js masque le bloc (o:0) puis lui
/// pose ces classes JX quand il entre à l'écran. [index] décale l'entrée
/// des éléments d'une même grille.
Map<String, String> reveal({String anim = 'anim:slide-up adur:700!', int index = 0}) {
  return {'data-reveal': '$anim ${_stagger[index % _stagger.length]}'.trim()};
}

/// Variantes d'apparition disponibles pour [reveal].
abstract final class Reveal {
  static const up = 'anim:slide-up adur:700!';
  static const fade = 'anim:fade-in adur:1000!';
  static const zoom = 'anim:zoom-in adur:700!';
}

/// Conteneur centré à largeur maximale.
Component container(List<Component> children, {String classes = ''}) {
  return div(classes: 'mw:[76rem] mx:auto px:6 $classes', children);
}

/// Photo responsive : dimensions réservées (pas de décalage de mise en page)
/// et chargement différé hors du premier écran.
Component photo(String src, {required String alt, String classes = '', bool eager = false}) {
  return img(
    src: '/$src',
    alt: alt,
    width: 1400,
    height: 933,
    classes: 'd:block w:full h:full obf:cover $classes',
    attributes: {'loading': eager ? 'eager' : 'lazy', 'decoding': 'async', if (eager) 'fetchpriority': 'high'},
  );
}

/// Bandeau de titre des pages intérieures : photo assombrie, titre, puis
/// fil d'Ariane sur une barre claire (style natif des JxBreadcrumbs).
Component pageHero({
  required String title,
  required String subtitle,
  required List<JxBreadcrumb> breadcrumbs,
  String image = Photos.hero,
}) {
  return div([
    section(classes: 'pos:relative bg:ink c:white ov:hidden', [
      div(classes: 'pos:absolute inset:0 anim:fade-in adur:1000! motion-reduce:anim:none', attributes: {'aria-hidden': 'true'}, [photo(image, alt: '', eager: true)]),
      div(classes: 'pos:absolute inset:0 grad:to-r from:ink via:ink to:transparent o:80', attributes: {'aria-hidden': 'true'}, []),
      div(classes: 'pos:absolute inset:0 bg:ink o:50 lg:d:none', attributes: {'aria-hidden': 'true'}, []),
      container(classes: 'pos:relative py:16 md:py:[6rem]', [
        span(classes: 'inline-flex ai:center gap:2 fs:sm fw:bold uppercase ls:[0.15em] c:brand anim:fade-in adur:700! motion-reduce:anim:none', [
          span(classes: 'w:8 h:[2px] bg:brand', attributes: {'aria-hidden': 'true'}, []),
          .text(Company.name),
        ]),
        h1(classes: 'mt:4 fs:4xl md:fs:5xl fw:extrabold tw:balance mw:[44rem] anim:slide-up adur:700! adelay:100! motion-reduce:anim:none', [.text(title)]),
        p(classes: 'mt:4 mw:[38rem] fs:lg c:gray-300 lh:relaxed anim:slide-up adur:700! adelay:250! motion-reduce:anim:none', [.text(subtitle)]),
      ]),
    ]),
    div(classes: 'bg:stone bwb:1 bc:gray-100', [
      container(classes: 'py:3', [JxBreadcrumbs(breadcrumbs, classes: 'fs:sm')]),
    ]),
  ]);
}

/// Sur-titre + titre + texte d'une section.
Component sectionHeading({required String eyebrow, required String title, String? text, bool center = false, bool dark = false}) {
  return div(classes: center ? 'mw:[44rem] mx:auto ta:center mb:12' : 'mw:[44rem] mb:12', attributes: reveal(), [
    span(classes: 'inline-flex ai:center gap:2 fs:sm fw:bold uppercase ls:[0.15em] c:brand', [
      span(classes: 'w:8 h:[2px] bg:brand', attributes: {'aria-hidden': 'true'}, []),
      .text(eyebrow),
    ]),
    h2(classes: dark ? 'mt:3 fs:3xl md:fs:4xl fw:extrabold c:white tw:balance' : 'mt:3 fs:3xl md:fs:4xl fw:extrabold c:ink tw:balance', [.text(title)]),
    if (text != null)
      p(classes: dark ? 'mt:4 fs:lg c:gray-300 lh:relaxed' : 'mt:4 fs:lg c:gray-500 lh:relaxed', [.text(text)]),
  ]);
}

/// Carte de service (liste et accueil).
Component serviceCard(Service s, {int index = 0}) {
  // L'enveloppe porte l'animation d'entrée, la carte garde son effet de survol.
  return div(attributes: reveal(index: index), [_serviceCard(s)]);
}

Component _serviceCard(Service s) {
  return a(
    href: '/services/${s.slug}',
    classes: 'group pos:relative h:full flex fd:column gap:4 p:8 br:xl bg:white bw:1 bc:gray-100 sh:sm ov:hidden hover:sh:xl hover:ty:[-4px] hover:bc:brand tr:all dur:300 focus-visible:ring:2 focus-visible:ringc:brand',
    [
      span(classes: 'pos:absolute top:0 left:0 h:1 w:full bg:brand o:0 group-hover:o:100 tr:all dur:300', attributes: {'aria-hidden': 'true'}, []),
      span(classes: 'w:14 h:14 br:lg bg:brandl c:brand flex ai:center jc:center group-hover:bg:brand group-hover:c:white tr:all dur:300', [
        icon(s.icon, classes: 'w:7 h:7'),
      ]),
      h3(classes: 'fs:xl fw:bold c:ink', [.text(s.title)]),
      p(classes: 'c:gray-500 lh:relaxed grow:1', [.text(s.summary)]),
      span(classes: 'inline-flex ai:center gap:2 fs:sm fw:semibold c:brand', [
        .text('En savoir plus'),
        icon('arrow', classes: 'w:4 h:4 group-hover:tx:1 tr:all dur:300'),
      ]),
    ],
  );
}

/// Visuel d'un chantier : la photo si elle existe, sinon un aplat dégradé.
Component projectVisual(Project pr, {String classes = 'ar:[4/3]'}) {
  final image = pr.image;
  if (image != null) {
    return div(classes: 'ov:hidden $classes', [photo(image, alt: pr.title)]);
  }
  return div(classes: 'pos:relative w:full ${pr.visual} $classes', attributes: {'role': 'img', 'aria-label': pr.title}, [
    div(classes: 'pos:absolute inset:0 flex ai:center jc:center c:white o:30', [icon('building', classes: 'w:16 h:16')]),
  ]);
}

/// Carte d'une réalisation : photo, voile au survol, catégorie et métadonnées.
Component projectCard(Project pr, {int index = 0}) {
  return article(attributes: reveal(index: index), classes: 'group br:xl ov:hidden bg:white bw:1 bc:gray-100 sh:sm hover:sh:xl tr:all dur:300 flex fd:column', [
    div(classes: 'pos:relative ov:hidden', [
      div(classes: 'group-hover:sc:105 tr:all dur:500 motion-reduce:tr:none', [projectVisual(pr)]),
      div(classes: 'pos:absolute inset:0 grad:to-t from:ink to:transparent o:40 group-hover:o:60 tr:all dur:300', attributes: {'aria-hidden': 'true'}, []),
      span(classes: 'pos:absolute top:4 left:4', [JxBadge(categoryLabel(pr.category), classes: 'bg:white! c:ink! sh:sm')]),
      span(classes: 'pos:absolute bottom:4 left:4 inline-flex ai:center gap:1 fs:xs fw:semibold c:white', [
        icon('calendar', classes: 'w:4 h:4'),
        .text('${pr.year}'),
      ]),
    ]),
    div(classes: 'p:6 flex fd:column gap:2 grow:1', [
      h3(classes: 'fs:lg fw:bold c:ink', [.text(pr.title)]),
      p(classes: 'c:gray-500 fs:sm lh:relaxed grow:1', [.text(pr.summary)]),
      span(classes: 'mt:2 inline-flex ai:center gap:1 fs:xs c:gray-500', [icon('pin', classes: 'w:4 h:4 c:brand'), .text(pr.location)]),
    ]),
  ]);
}

/// Bandeau d'appel à l'action sur photo.
Component ctaBand({String title = 'Un projet de construction ou de rénovation ?', String text = 'Parlez-nous de votre projet : visite et devis détaillé gratuits, sans engagement.'}) {
  return section(classes: 'pos:relative bg:brand ov:hidden', [
    div(classes: 'pos:absolute inset:0 o:20', attributes: {'aria-hidden': 'true'}, [photo(Photos.rebar, alt: '', classes: 'mix:multiply')]),
    div(classes: 'pos:absolute inset:0 grad:to-r from:brandd to:brand o:90', attributes: {'aria-hidden': 'true'}, []),
    container(classes: 'pos:relative py:16 flex fd:column lg:fd:row ai:start lg:ai:center jc:between gap:8', [
      div(attributes: reveal(), [
        h2(classes: 'fs:3xl fw:extrabold c:white tw:balance', [.text(title)]),
        p(classes: 'mt:3 fs:lg c:brandl', [.text(text)]),
      ]),
      div(classes: 'flex flw:wrap gap:3', attributes: reveal(anim: Reveal.zoom, index: 2), [
        JxButton([.text('Demander un devis')], href: '/contact', size: JxButtonSize.lg, classes: 'bg:white! c:brandd! hover:bg:brandl!'),
        JxButton(
          [icon('phone', classes: 'w:5 h:5'), .text(Company.phone)],
          href: Company.phoneHref,
          variant: JxButtonVariant.outline,
          size: JxButtonSize.lg,
          classes: 'bc:white! c:white! bg:transparent! hover:bg:brandd!',
        ),
      ]),
    ]),
  ]);
}

/// Liste à puces avec coche.
Component tickList(List<String> items, {String classes = ''}) {
  return ul(classes: 'flex fd:column gap:3 $classes', [
    for (final (i, item) in items.indexed)
      li(classes: 'flex ai:start gap:3', attributes: reveal(index: i), [
        span(classes: 'mt:[2px] w:5 h:5 br:full bg:brand c:white flex ai:center jc:center shrink:0', [icon('tick', classes: 'w:3 h:3')]),
        span(classes: 'c:gray-700', [.text(item)]),
      ]),
  ]);
}
