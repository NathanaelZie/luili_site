import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/site_footer.dart';
import 'components/site_header.dart';
import 'data/site_data.dart';
import 'pages/about.dart';
import 'pages/contact.dart';
import 'pages/home.dart';
import 'pages/legal.dart';
import 'pages/not_found.dart';
import 'pages/realisations.dart';
import 'pages/services.dart';

/// Chemins publics du site (utilisés aussi pour le sitemap).
const List<String> publicPaths = ['/', '/services', '/realisations', '/a-propos', '/contact', '/mentions-legales'];

/// Toutes les pages du site : sitemap et export statique (tool/export_static.dart).
List<String> get allPaths => [
  ...publicPaths,
  for (final s in services) '/services/${s.slug}',
  for (final c in projectCategories) '/realisations/${c.value}',
];

/// Composant racine, rendu entièrement côté serveur : aucune page n'envoie
/// de JavaScript au navigateur.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex fd:column mnh:screen bg:white c:ink antialiased', [
      a(href: '#contenu', classes: 'sr-only focus:not-sr-only focus:pos:absolute focus:top:2 focus:left:2 focus:z:50 focus:bg:white focus:px:4 focus:py:3 focus:br:md focus:sh:lg fw:semibold c:ink', [
        .text('Aller au contenu'),
      ]),
      const SiteHeader(),
      Component.element(
        tag: 'main',
        id: 'contenu',
        classes: 'grow:1',
        children: [
          Router(
            routes: [
              Route(path: '/', builder: (context, state) => const HomePage()),
              Route(path: '/services', builder: (context, state) => const ServicesPage()),
              Route(path: '/services/:slug', builder: (context, state) => ServiceDetailPage(slug: state.params['slug'] ?? '')),
              Route(path: '/realisations', builder: (context, state) => const RealisationsPage()),
              Route(
                path: '/realisations/:categorie',
                builder: (context, state) => RealisationsPage(category: state.params['categorie']),
              ),
              Route(path: '/a-propos', builder: (context, state) => const AboutPage()),
              Route(
                path: '/contact',
                builder: (context, state) => ContactPage(status: state.queryParams['statut'], service: state.queryParams['service']),
              ),
              Route(path: '/mentions-legales', builder: (context, state) => const LegalPage()),
            ],
            errorBuilder: (context, state) => const NotFoundPage(),
          ),
        ],
      ),
      const SiteFooter(),
    ]);
  }
}
