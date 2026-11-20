import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../components/sections.dart';
import '../data/site_data.dart';

/// Liste des chantiers, filtrable par catégorie (?categorie=…) côté serveur.
class RealisationsPage extends StatelessComponent {
  const RealisationsPage({this.category, super.key});

  /// Valeur brute du paramètre d'URL : ignorée si elle n'est pas connue.
  final String? category;

  @override
  Component build(BuildContext context) {
    final active = projectCategories.any((c) => c.value == category) ? category : null;
    final list = active == null ? projects : projects.where((x) => x.category == active).toList();

    return div([
      seo(title: 'Nos réalisations', description: 'Bâtiments, rénovations et travaux publics réalisés par ${Company.name}.'),
      pageHero(
        title: 'Nos réalisations',
        subtitle: 'Un aperçu des chantiers que nous avons menés pour des particuliers, des entreprises et des collectivités.',
        breadcrumbs: const [(label: 'Accueil', href: '/'), (label: 'Réalisations', href: null)],
      ),
      section(classes: 'bg:stone py:[4rem]', [
        container([
          nav(classes: 'flex flw:wrap gap:2 mb:10', attributes: {'aria-label': 'Filtrer par catégorie'}, [
            _filter('Tout', '/realisations', active == null),
            for (final c in projectCategories) _filter(c.label, '/realisations?categorie=${c.value}', active == c.value),
          ]),
          if (list.isEmpty)
            const JxEmptyState(title: 'Aucune réalisation dans cette catégorie pour le moment.')
          else
            div(classes: 'grid gap:6 md:cols:2 lg:cols:3', [for (final (i, x) in list.indexed) projectCard(x, index: i % 3)]),
        ]),
      ]),
      ctaBand(title: 'Votre chantier pourrait être le prochain', text: 'Confiez-nous votre projet et suivez son avancement à chaque étape.'),
    ]);
  }

  Component _filter(String label, String href, bool selected) {
    return a(
      href: href,
      attributes: {if (selected) 'aria-current': 'page'},
      classes: selected
          ? 'px:5 py:2 br:full fs:sm fw:semibold bg:brand c:white'
          : 'px:5 py:2 br:full fs:sm fw:medium bg:white c:gray-700 bw:1 bc:gray-100 hover:bc:brand hover:c:brand',
      [.text(label)],
    );
  }
}
