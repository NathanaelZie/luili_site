/// Exporte le site en fichiers statiques (GitHub Pages ou tout hébergeur
/// statique).
///
/// Démarre le serveur Dart en production sur un port local, enregistre
/// chaque page listée dans le sitemap, copie `web/` et génère la feuille JX.
///
///   dart run tool/export_static.dart --base /depot/ --url https://compte.github.io/depot --out build/pages
///
/// - `--base` : chemin du site sur l'hébergeur (`/` pour un domaine propre).
/// - `--url`  : URL publique complète (sitemap et robots.txt).
/// - `--out`  : dossier de sortie (vidé avant l'export).
///
/// Limite : le formulaire de contact a besoin du serveur (POST /api/contact)
/// et ne fonctionne donc pas sur un hébergement statique.
library;

import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final options = _parse(args);
  final base = _normalizeBase(options['base'] ?? '/');
  final publicUrl = (options['url'] ?? 'http://localhost$base').replaceAll(RegExp(r'/+$'), '');
  final out = Directory(options['out'] ?? 'build/pages');
  const port = 8097;

  stdout.writeln('1/4 Démarrage du serveur…');
  final server = await Process.start(
    Platform.resolvedExecutable,
    ['run', '-Djaspr.flags.release=true', 'lib/main.server.dart'],
    environment: {'APP_ENV': 'production', 'HOST': '127.0.0.1', 'PORT': '$port', 'PUBLIC_URL': publicUrl},
  );
  // Les deux flux doivent être lus, sinon le tampon plein bloque le serveur.
  server.stdout.drain<void>();
  server.stderr.transform(utf8.decoder).listen(stderr.write);
  final client = HttpClient();
  final origin = 'http://127.0.0.1:$port';

  try {
    await _waitFor(client, '$origin/sante');

    stdout.writeln('2/4 Export des pages vers ${out.path}…');
    if (out.existsSync()) out.deleteSync(recursive: true);
    out.createSync(recursive: true);

    final sitemap = (await _get(client, '$origin/sitemap.xml')).body;
    // Chemins des pages : URL du sitemap moins le préfixe de l'URL publique.
    final prefix = Uri.parse(publicUrl).path;
    final paths = [
      for (final m in RegExp(r'<loc>([^<]+)</loc>').allMatches(sitemap))
        switch (Uri.parse(m.group(1)!.replaceAll('&amp;', '&')).path) {
          final p when p.startsWith(prefix) && p.length > prefix.length => p.substring(prefix.length),
          _ => '/',
        },
    ];

    for (final path in paths) {
      final page = await _get(client, '$origin$path');
      if (page.status != 200) throw StateError('$path : statut ${page.status}');
      final file = File('${out.path}${path == '/' ? '' : path}/index.html');
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(_rewrite(page.body, base));
      stdout.writeln('   $path');
    }

    // Page d'erreur servie par GitHub Pages pour toute adresse inconnue.
    final missing = await _get(client, '$origin/page-introuvable-export');
    File('${out.path}/404.html').writeAsStringSync(_rewrite(missing.body, base));
    File('${out.path}/sitemap.xml').writeAsStringSync(sitemap);
    File('${out.path}/robots.txt').writeAsStringSync((await _get(client, '$origin/robots.txt')).body);
    // Désactive Jekyll : les fichiers sont servis tels quels.
    File('${out.path}/.nojekyll').writeAsStringSync('');
  } finally {
    client.close(force: true);
    server.kill();
  }

  stdout.writeln('3/4 Copie des fichiers de web/…');
  _copyDir(Directory('web'), out);

  // Écrite directement dans la sortie : un web/jx.css dans les sources
  // entrerait en conflit avec le builder de `jaspr serve`.
  stdout.writeln('4/4 Génération de jx.css…');
  await _run(Platform.resolvedExecutable, ['run', 'jx_cli:jx', 'build', '-o', '${out.path}/jx.css']);
  stdout.writeln('Terminé : ${out.path} (base $base, $publicUrl)');
}

/// Adapte une page rendue par le serveur à l'hébergement statique.
String _rewrite(String html, String base) {
  return html
      // Point d'entrée Jaspr côté client : inutile, aucun composant @client.
      .replaceAll(RegExp(r'\s*<script src="main\.client\.dart\.js"[^>]*></script>'), '')
      // Liens et ressources absolus (/services…) préfixés par le chemin du
      // site ; <base href="/"> devient aussi <base href="$base">.
      .replaceAllMapped(RegExp(r'\b(href|src|action)="/(?!/)'), (m) => '${m[1]}="$base');
}

String _normalizeBase(String base) {
  var b = base.trim();
  if (!b.startsWith('/')) b = '/$b';
  if (!b.endsWith('/')) b = '$b/';
  return b;
}

Map<String, String> _parse(List<String> args) {
  final result = <String, String>{};
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i].startsWith('--')) result[args[i].substring(2)] = args[++i];
  }
  return result;
}

Future<void> _run(String exe, List<String> args) async {
  final r = await Process.run(exe, args, runInShell: false);
  stdout.write(r.stdout);
  if (r.exitCode != 0) {
    stderr.write(r.stderr);
    exit(r.exitCode);
  }
}

Future<({int status, String body})> _get(HttpClient client, String url) async {
  for (var attempt = 1; ; attempt++) {
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      return (status: response.statusCode, body: await response.transform(utf8.decoder).join());
    } on HttpException {
      // Connexion persistante fermée par le serveur : on réessaie.
      if (attempt >= 3) rethrow;
    }
  }
}

Future<void> _waitFor(HttpClient client, String url) async {
  for (var i = 0; i < 120; i++) {
    try {
      if ((await _get(client, url)).status == 200) return;
    } on SocketException {
      // Serveur pas encore prêt.
    }
    await Future<void>.delayed(const Duration(seconds: 1));
  }
  throw StateError('Le serveur ne répond pas sur $url');
}

void _copyDir(Directory from, Directory to) {
  for (final entity in from.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relative = entity.path.substring(from.path.length + 1);
    final target = File('${to.path}/$relative');
    target.parent.createSync(recursive: true);
    entity.copySync(target.path);
  }
}
