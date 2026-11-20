import 'dart:io';

/// Configuration du serveur, lue dans les variables d'environnement.
///
/// | Variable        | Défaut        | Rôle                                                  |
/// |-----------------|---------------|-------------------------------------------------------|
/// | `APP_ENV`       | `development` | `production` active HSTS et les en-têtes stricts.     |
/// | `HOST`          | `0.0.0.0`     | Adresse d'écoute.                                     |
/// | `PORT`          | `8080`        | Port d'écoute.                                        |
/// | `TRUST_PROXY`   | `false`       | `true` derrière un reverse proxy (lit X-Forwarded-For). |
/// | `PUBLIC_URL`    | —             | URL publique, ex. https://luili-construction.com (sitemap). |
/// | `DATA_DIR`      | `data`        | Dossier des demandes de contact (hors de `web/`).     |
class ServerConfig {
  ServerConfig._({
    required this.production,
    required this.host,
    required this.port,
    required this.trustProxy,
    required this.publicUrl,
    required this.dataDir,
  });

  factory ServerConfig.fromEnvironment([Map<String, String>? env]) {
    final e = env ?? Platform.environment;
    return ServerConfig._(
      production: e['APP_ENV'] == 'production',
      host: e['HOST'] ?? '0.0.0.0',
      port: int.tryParse(e['PORT'] ?? '') ?? 8080,
      trustProxy: e['TRUST_PROXY'] == 'true',
      publicUrl: e['PUBLIC_URL']?.replaceAll(RegExp(r'/+$'), ''),
      dataDir: e['DATA_DIR'] ?? 'data',
    );
  }

  final bool production;
  final String host;
  final int port;
  final bool trustProxy;
  final String? publicUrl;
  final String dataDir;
}
