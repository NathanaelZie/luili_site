/// Point d'entrée du serveur : rendu des pages, formulaire de contact,
/// fichiers SEO et en-têtes de sécurité.
library;

import 'dart:convert';
import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'app.dart';
import 'data/site_data.dart';
import 'server/config.dart';
import 'server/contact.dart';
import 'server/rate_limiter.dart';
import 'server/security.dart';

// Fichier généré automatiquement par Jaspr, ne pas modifier.
import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  final config = ServerConfig.fromEnvironment();
  final contactStore = JsonlContactStore(config.dataDir);
  // 5 demandes par adresse IP toutes les 15 minutes.
  final contactLimiter = MemoryRateLimiter(maxHits: 5, window: const Duration(minutes: 15));

  final router = Router()
    ..post(
      '/api/contact',
      contactHandler(store: contactStore, limiter: contactLimiter, trustProxy: config.trustProxy),
    )
    // Sonde de santé pour un répartiteur de charge ou un orchestrateur.
    ..get('/sante', (Request _) => Response.ok('ok', headers: {'content-type': 'text/plain; charset=utf-8'}))
    ..get('/robots.txt', (Request request) => _text(_robots(_baseUrl(request, config))))
    ..get('/sitemap.xml', (Request request) => _sitemap(_baseUrl(request, config)))
    ..all('/api/<ignored|.*>', (Request _) => Response.notFound('Introuvable'))
    ..mount(
      '/',
      serveApp((request, render) {
        return render(
          Document(
            title: Company.name,
            lang: 'fr',
            meta: {'description': Company.description, 'theme-color': '#e8590c'},
            head: [
              link(rel: 'stylesheet', href: '/jx.css'),
              link(rel: 'icon', href: '/favicon.ico'),
              // Animations au défilement (fichier local, compatible CSP).
              const script(src: '/reveal.js', defer: true),
            ],
            body: const App(),
          ),
        );
      }),
    );

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(allowedMethods())
      .addMiddleware(securityHeaders(production: config.production))
      .addHandler(router.call);

  // Verrou qui gère les rechargements à chaud successifs en développement.
  final reloadLock = activeReloadLock = Object();

  final server = await shelf_io.serve(
    handler,
    config.host,
    config.port,
    shared: true,
    // N'annonce pas la technologie du serveur.
    poweredByHeader: null,
  );
  server.autoCompress = true;
  server.idleTimeout = const Duration(seconds: 30);

  if (reloadLock != activeReloadLock) {
    server.close();
    return;
  }

  activeServer?.close();
  activeServer = server;

  print('Serveur prêt sur http://${server.address.host}:${server.port} (${config.production ? 'production' : 'développement'})');
}

/// URL publique du site : PUBLIC_URL en production, sinon déduite de la requête.
String _baseUrl(Request request, ServerConfig config) {
  if (config.publicUrl case final url?) return url;
  final uri = request.requestedUri;
  return '${uri.scheme}://${uri.authority}';
}

Response _text(String body) => Response.ok(body, headers: {'content-type': 'text/plain; charset=utf-8'});

String _robots(String base) => 'User-agent: *\nDisallow: /api/\nAllow: /\n\nSitemap: $base/sitemap.xml\n';

Response _sitemap(String base) {
  final urls = allPaths;
  final body = StringBuffer('<?xml version="1.0" encoding="UTF-8"?>\n')
    ..writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
  for (final path in urls) {
    body.writeln('  <url><loc>${const HtmlEscape(HtmlEscapeMode.element).convert('$base$path')}</loc></url>');
  }
  body.writeln('</urlset>');
  return Response.ok(body.toString(), headers: {'content-type': 'application/xml; charset=utf-8'});
}

/// Serveur HTTP actif (remplacé à chaque rechargement à chaud).
HttpServer? activeServer;

/// Dernier verrou de rechargement créé.
Object? activeReloadLock;
