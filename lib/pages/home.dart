import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../components/icons.dart';
import '../components/sections.dart';
import '../data/site_data.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return div([
      seo(title: Company.name, description: Company.description),
      _hero(),
      _figures(),
      _servicesSection(),
      _whyUs(),
      _projectsSection(),
      _process(),
      ctaBand(),
    ]);
  }

  Component _hero() {
    return section(classes: 'pos:relative bg:ink c:white ov:hidden', [
      // Photo plein cadre, assombrie à gauche pour la lisibilité du texte.
      div(classes: 'pos:absolute inset:0 anim:fade-in adur:1000! motion-reduce:anim:none', attributes: {'aria-hidden': 'true'}, [photo(Photos.hero, alt: '', eager: true)]),
      div(classes: 'pos:absolute inset:0 grad:to-r from:ink via:ink to:transparent o:80', attributes: {'aria-hidden': 'true'}, []),
      div(classes: 'pos:absolute inset:0 bg:ink o:50 lg:d:none', attributes: {'aria-hidden': 'true'}, []),
      div(classes: 'pos:absolute inset:0 grad:to-t from:ink to:transparent o:40', attributes: {'aria-hidden': 'true'}, []),
      container(classes: 'pos:relative pt:[5rem] pb:[7rem] md:pt:[8rem] md:pb:[10rem] grid gap:12 lg:cols:12 ai:end', [
        div(classes: 'lg:span:7', [
          span(classes: 'd:inline-block anim:zoom-in adur:700! motion-reduce:anim:none', [
            JxBadge('Entreprise générale BTP depuis ${Company.foundedYear}', classes: 'bg:brand! c:white! sh:md'),
          ]),
          h1(classes: 'mt:6 fs:4xl md:fs:6xl fw:extrabold lh:tight tw:balance anim:slide-up adur:700! adelay:100! motion-reduce:anim:none', [
            .text('Nous bâtissons '),
            span(classes: 'c:brand', [.text('vos projets')]),
            .text(', du plan à la remise des clés.'),
          ]),
          p(classes: 'mt:6 fs:lg md:fs:xl c:gray-300 lh:relaxed mw:[36rem] anim:slide-up adur:700! adelay:250! motion-reduce:anim:none', [
            .text('Construction neuve, rénovation, gros œuvre et travaux publics : '
                'une équipe d\'ingénieurs et d\'artisans qui s\'engage sur les coûts, les délais et la qualité.'),
          ]),
          div(classes: 'mt:8 flex flw:wrap gap:3 anim:slide-up adur:700! adelay:400! motion-reduce:anim:none', [
            JxButton([.text('Demander un devis gratuit')], href: '/contact', size: JxButtonSize.lg, classes: 'bg:brand! hover:bg:brandd! sh:lg'),
            JxButton(
              [.text('Voir nos réalisations'), icon('arrow', classes: 'w:5 h:5')],
              href: '/realisations',
              variant: JxButtonVariant.outline,
              size: JxButtonSize.lg,
              classes: 'bc:white! c:white! bg:transparent! hover:bg:ink!',
            ),
          ]),
        ]),
        // Engagements en verre dépoli (grand écran).
        div(classes: 'd:none lg:block lg:span:5', [
          div(classes: 'br:2xl bw:1 bc:inkl bg:[rgba(20,24,31,0.55)] bblur:lg p:8 flex fd:column gap:5 anim:fade-in adur:1000! adelay:300! motion-reduce:anim:none', [
            for (final (i, c) in commitments.take(3).indexed)
              div(classes: switch (i) {
                0 => 'flex gap:4 anim:slide-up adur:700! adelay:500! motion-reduce:anim:none',
                1 => 'flex gap:4 anim:slide-up adur:700! adelay:650! motion-reduce:anim:none',
                _ => 'flex gap:4 anim:slide-up adur:700! adelay:800! motion-reduce:anim:none',
              }, [
                span(classes: 'w:11 h:11 br:lg bg:brand c:white flex ai:center jc:center shrink:0', [icon(c.icon, classes: 'w:5 h:5')]),
                div([
                  p(classes: 'fw:bold', [.text(c.title)]),
                  p(classes: 'mt:1 fs:sm c:gray-300 lh:relaxed', [.text(c.text)]),
                ]),
              ]),
          ]),
        ]),
      ]),
    ]);
  }

  /// Chiffres clés dans une carte qui chevauche le bas du bandeau.
  Component _figures() {
    return section(classes: 'pos:relative z:10', [
      container(classes: 'mt:[-4rem]', [
        div(classes: 'grid cols:2 lg:cols:4 br:2xl bg:white sh:xl bw:1 bc:gray-100 ov:hidden anim:slide-up adur:700! adelay:500! motion-reduce:anim:none', [
          for (final (i, f) in keyFigures.indexed)
            div(classes: i.isEven ? 'p:6 md:p:8 ta:center bwr:1 bwb:1 lg:bwb:0 bc:gray-100' : 'p:6 md:p:8 ta:center bwb:1 lg:bwb:0 lg:bwr:1 bc:gray-100', [
              p(classes: 'fs:3xl md:fs:4xl fw:extrabold c:brand', attributes: {'data-count': ''}, [.text(f.value)]),
              p(classes: 'mt:1 fs:xs md:fs:sm c:gray-500 uppercase ls:[0.08em]', [.text(f.label)]),
            ]),
        ]),
      ]),
    ]);
  }

  Component _servicesSection() {
    return section(classes: 'bg:stone pt:[6rem] pb:[5rem] mt:[-4rem]', [
      container([
        sectionHeading(
          eyebrow: 'Nos métiers',
          title: 'Un seul interlocuteur pour tout votre projet',
          text: 'De l\'étude à la livraison, nos équipes couvrent l\'ensemble des corps d\'état du bâtiment et des travaux publics.',
          center: true,
        ),
        div(classes: 'grid gap:6 md:cols:2 lg:cols:3', [for (final (i, s) in services.indexed) serviceCard(s, index: i % 3)]),
      ]),
    ]);
  }

  Component _whyUs() {
    return section(classes: 'bg:white py:[5rem]', [
      container(classes: 'grid gap:12 lg:cols:2 ai:center', [
        div(classes: 'grid cols:2 gap:4', [
          div(classes: 'ar:[3/4] br:xl ov:hidden sh:lg', attributes: reveal(anim: Reveal.zoom), [photo(Photos.engineer, alt: 'Ingénieur consultant les plans sur un chantier')]),
          div(classes: 'flex fd:column gap:4 pt:12', [
            div(classes: 'ar:square br:xl ov:hidden sh:lg', attributes: reveal(anim: Reveal.zoom, index: 2), [photo(Photos.rebar, alt: 'Ferraillage de dalle en cours sur un chantier')]),
            div(classes: 'br:xl bg:brand c:white p:6', attributes: reveal(index: 4), [
              p(classes: 'fs:4xl fw:extrabold', attributes: {'data-count': ''}, [.text('${DateTime.now().year - Company.foundedYear} ans')]),
              p(classes: 'fs:sm c:brandl', [.text('d\'expertise sur le terrain')]),
            ]),
          ]),
        ]),
        div([
          sectionHeading(
            eyebrow: 'Pourquoi nous choisir',
            title: 'Des chantiers maîtrisés, des clients sereins',
            text: 'Nous croyons qu\'un bon chantier se joue avant le premier coup de pioche : '
                'un devis clair, un planning réaliste et une communication régulière.',
          ),
          div(classes: 'grid sm:cols:2 gap:6 mt:[-1rem]', [
            for (final (i, c) in commitments.indexed)
              div(classes: 'flex gap:4', attributes: reveal(index: i), [
                span(classes: 'w:12 h:12 br:lg bg:brandl c:brand flex ai:center jc:center shrink:0', [icon(c.icon, classes: 'w:6 h:6')]),
                div([
                  h3(classes: 'fw:bold c:ink', [.text(c.title)]),
                  p(classes: 'mt:1 fs:sm c:gray-500 lh:relaxed', [.text(c.text)]),
                ]),
              ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _projectsSection() {
    return section(classes: 'bg:stone py:[5rem]', [
      container([
        div(classes: 'flex fd:column md:fd:row md:ai:end jc:between gap:6 mb:12', [
          div(classes: 'mb:[-3rem]', [
            sectionHeading(eyebrow: 'Réalisations', title: 'Nos derniers chantiers'),
          ]),
          JxButton([.text('Toutes les réalisations'), icon('arrow', classes: 'w:4 h:4')], href: '/realisations', variant: JxButtonVariant.outline),
        ]),
        div(classes: 'grid gap:6 md:cols:2 lg:cols:3', [for (final (i, x) in projects.take(3).indexed) projectCard(x, index: i)]),
      ]),
    ]);
  }

  Component _process() {
    return section(classes: 'bg:ink py:[5rem]', [
      container([
        sectionHeading(eyebrow: 'Notre méthode', title: 'Votre projet en 4 étapes', center: true, dark: true),
        ol(classes: 'grid gap:6 md:cols:2 lg:cols:4', [
          for (final (i, step) in processSteps.indexed)
            li(classes: 'pos:relative br:xl bg:inkl p:8 bw:1 bc:inkl hover:bc:brand tr:all dur:300', attributes: reveal(index: i), [
              span(classes: 'fs:5xl fw:extrabold c:brand o:40', [.text('0${i + 1}')]),
              h3(classes: 'mt:2 fs:xl fw:bold c:white', [.text(step.title)]),
              p(classes: 'mt:2 c:gray-300 fs:sm lh:relaxed', [.text(step.text)]),
            ]),
        ]),
      ]),
    ]);
  }
}
