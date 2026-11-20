/// Contenu éditorial du site Luili Construction.
///
/// Tout le texte du site est centralisé ici : les pages ne font que l'afficher.
/// Pour brancher plus tard un CMS ou une base de données, il suffit de
/// remplacer ces constantes par un chargement (le reste du code ne change pas).
///
/// ⚠️ Les valeurs marquées « À REMPLACER » sont des exemples à corriger
/// avant la mise en ligne (coordonnées, chiffres, réalisations).
library;

// ---------------------------------------------------------------------------
// Entreprise
// ---------------------------------------------------------------------------

abstract final class Company {
  static const name = 'Luili Construction';
  static const tagline = 'Bâtir solide, livrer à temps.';
  static const description =
      'Entreprise générale du bâtiment et des travaux publics : construction neuve, '
      'rénovation, gros œuvre, VRD et maîtrise d\'œuvre, de l\'étude à la remise des clés.';

  // À REMPLACER : coordonnées réelles.
  static const phone = '+226 XX XX XX XX';
  static const phoneHref = 'tel:+226XXXXXXXX';
  static const whatsappHref = 'https://wa.me/226XXXXXXXX';
  static const email = 'contact@votre-domaine.com';
  static const address = 'Adresse du siège, Ville';
  static const hours = 'Lun – Ven : 7h30 – 17h30 · Sam : 8h – 12h';
  static const foundedYear = 2014; // À REMPLACER

  static const facebook = 'https://facebook.com/';
  static const linkedin = 'https://linkedin.com/';
}

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

typedef NavItem = ({String label, String path});

const List<NavItem> mainNav = [
  (label: 'Accueil', path: '/'),
  (label: 'Services', path: '/services'),
  (label: 'Réalisations', path: '/realisations'),
  (label: 'À propos', path: '/a-propos'),
  (label: 'Contact', path: '/contact'),
];

// ---------------------------------------------------------------------------
// Services
// ---------------------------------------------------------------------------

class Service {
  const Service({
    required this.slug,
    required this.title,
    required this.icon,
    required this.summary,
    required this.intro,
    required this.points,
    required this.steps,
    required this.image,
  });

  /// Identifiant d'URL : `/services/<slug>`.
  final String slug;
  final String title;

  /// Nom d'une icône de [icons.dart].
  final String icon;
  final String summary;
  final String intro;
  final List<String> points;
  final List<String> steps;

  /// Photo de fond de la page du service.
  final String image;
}

const List<Service> services = [
  Service(
    slug: 'construction-neuve',
    title: 'Construction neuve',
    icon: 'building',
    summary: 'Villas, immeubles et bâtiments commerciaux livrés clés en main.',
    intro:
        'Nous prenons en charge votre projet de construction de A à Z : implantation, fondations, '
        'élévation, toiture et finitions, avec un interlocuteur unique et un planning tenu.',
    points: [
      'Maisons individuelles et villas',
      'Immeubles résidentiels R+1 à R+5',
      'Bureaux, commerces et entrepôts',
      'Bâtiments scolaires et sanitaires',
    ],
    steps: ['Étude du terrain et du besoin', 'Plans et devis détaillé', 'Exécution et suivi hebdomadaire', 'Réception et remise des clés'],
    image: 'images/photos/chantier-structure.webp',
  ),
  Service(
    slug: 'renovation',
    title: 'Rénovation & réhabilitation',
    icon: 'hammer',
    summary: 'Remise à neuf, extension et mise aux normes de bâtiments existants.',
    intro:
        'Fissures, infiltrations, extension, changement d\'usage : nous diagnostiquons l\'existant '
        'et proposons des solutions durables, adaptées à votre budget.',
    points: [
      'Diagnostic structurel et reprise de fissures',
      'Extensions et surélévations',
      'Étanchéité et traitement de l\'humidité',
      'Réaménagement intérieur complet',
    ],
    steps: ['Visite et diagnostic', 'Proposition chiffrée', 'Travaux en site occupé si besoin', 'Contrôle et garantie'],
    image: 'images/photos/renovation.webp',
  ),
  Service(
    slug: 'gros-oeuvre',
    title: 'Gros œuvre & génie civil',
    icon: 'layers',
    summary: 'Fondations, structures béton armé, maçonnerie et ouvrages d\'art.',
    intro:
        'Le gros œuvre conditionne la solidité de tout l\'ouvrage. Nos équipes et notre matériel '
        'assurent des structures conformes aux plans et aux règles de l\'art.',
    points: [
      'Terrassement et fondations',
      'Structures en béton armé',
      'Maçonnerie et dallages',
      'Dalots, murs de soutènement, châteaux d\'eau',
    ],
    steps: ['Lecture des plans d\'exécution', 'Préparation et implantation', 'Coulage et contrôle qualité', 'Réception par étape'],
    image: 'images/photos/ferraillage.webp',
  ),
  Service(
    slug: 'travaux-publics',
    title: 'Travaux publics & VRD',
    icon: 'road',
    summary: 'Voiries, assainissement, réseaux divers et aménagements extérieurs.',
    intro:
        'Pour les collectivités comme pour les promoteurs, nous réalisons les voiries et réseaux '
        'divers qui rendent un site accessible et fonctionnel.',
    points: [
      'Voiries et pistes en latérite ou pavés',
      'Caniveaux et assainissement pluvial',
      'Réseaux d\'eau et d\'électricité',
      'Parkings et aménagements paysagers',
    ],
    steps: ['Relevés topographiques', 'Dimensionnement', 'Exécution par tronçons', 'Essais et réception'],
    image: 'images/photos/voirie.webp',
  ),
  Service(
    slug: 'etudes-maitrise-oeuvre',
    title: 'Études & maîtrise d\'œuvre',
    icon: 'ruler',
    summary: 'Plans, métrés, devis et pilotage de chantier pour sécuriser votre budget.',
    intro:
        'Avant de construire, il faut bien concevoir. Nous établissons plans, métrés et devis, '
        'puis pilotons le chantier pour garantir coûts, délais et qualité.',
    points: [
      'Plans architecturaux et d\'exécution',
      'Métrés et devis quantitatifs estimatifs',
      'Dossiers de permis de construire',
      'Suivi et contrôle de chantier',
    ],
    steps: ['Programme et esquisse', 'Avant-projet et chiffrage', 'Dossier d\'exécution', 'Pilotage des travaux'],
    image: 'images/photos/ingenieur-plans.webp',
  ),
  Service(
    slug: 'second-oeuvre',
    title: 'Second œuvre & finitions',
    icon: 'paint',
    summary: 'Carrelage, peinture, menuiserie, plomberie et électricité.',
    intro:
        'Les finitions font la différence au quotidien. Nous coordonnons tous les corps d\'état '
        'pour un rendu soigné et des installations fiables.',
    points: [
      'Carrelage, faïence et revêtements',
      'Peinture intérieure et extérieure',
      'Menuiserie bois, alu et métallique',
      'Plomberie, électricité et climatisation',
    ],
    steps: ['Choix des matériaux', 'Planning des corps d\'état', 'Pose et contrôles', 'Levée des réserves'],
    image: 'images/photos/villa.webp',
  ),
];

Service? serviceBySlug(String slug) {
  for (final s in services) {
    if (s.slug == slug) return s;
  }
  return null;
}

// ---------------------------------------------------------------------------
// Réalisations (À REMPLACER par vos vrais chantiers et photos)
// ---------------------------------------------------------------------------

class Project {
  const Project({
    required this.title,
    required this.category,
    required this.location,
    required this.year,
    required this.summary,
    required this.visual,
    this.image,
  });

  final String title;

  /// Une des valeurs de [projectCategories].
  final String category;
  final String location;
  final int year;
  final String summary;

  /// Classes JX du visuel de remplacement (affiché tant que [image] est vide).
  final String visual;

  /// Chemin d'une photo dans web/images/, ex. 'images/photos/villa.webp'.
  final String? image;
}

const List<({String value, String label})> projectCategories = [
  (value: 'batiment', label: 'Bâtiment'),
  (value: 'renovation', label: 'Rénovation'),
  (value: 'travaux-publics', label: 'Travaux publics'),
];

String categoryLabel(String value) {
  for (final c in projectCategories) {
    if (c.value == value) return c.label;
  }
  return value;
}

const List<Project> projects = [
  Project(
    title: 'Villa familiale R+1',
    category: 'batiment',
    location: 'Quartier résidentiel',
    year: 2025,
    summary: 'Villa de 280 m² avec terrasse accessible, livrée en 9 mois.',
    visual: 'grad:to-br from:orange-300 to:brandd',
    image: 'images/photos/villa.webp',
  ),
  Project(
    title: 'Immeuble de bureaux R+3',
    category: 'batiment',
    location: 'Centre-ville',
    year: 2024,
    summary: 'Structure béton armé, 1 200 m² de plateaux de bureaux.',
    visual: 'grad:to-br from:gray-500 to:ink',
    image: 'images/photos/immeuble-bureaux.webp',
  ),
  Project(
    title: 'Réhabilitation d\'une école',
    category: 'renovation',
    location: 'Commune rurale',
    year: 2024,
    summary: 'Reprise de toiture, étanchéité et réfection de 6 salles de classe.',
    visual: 'grad:to-br from:yellow-300 to:orange-700',
    image: 'images/photos/renovation.webp',
  ),
  Project(
    title: 'Voirie et caniveaux — 2,4 km',
    category: 'travaux-publics',
    location: 'Zone périurbaine',
    year: 2023,
    summary: 'Chaussée pavée, caniveaux maçonnés et éclairage public.',
    visual: 'grad:to-br from:gray-300 to:gray-700',
    image: 'images/photos/voirie.webp',
  ),
  Project(
    title: 'Extension d\'un centre de santé',
    category: 'renovation',
    location: 'Chef-lieu de province',
    year: 2023,
    summary: 'Nouveau bloc de 4 salles et mise aux normes des réseaux.',
    visual: 'grad:to-br from:teal-300 to:teal-900',
    image: 'images/photos/extension-parpaings.webp',
  ),
  Project(
    title: 'Entrepôt logistique',
    category: 'batiment',
    location: 'Zone industrielle',
    year: 2022,
    summary: 'Charpente métallique, dallage industriel de 2 000 m².',
    visual: 'grad:to-br from:orange to:red-900',
    image: 'images/photos/entrepot.webp',
  ),
];

// ---------------------------------------------------------------------------
// Chiffres clés (À REMPLACER)
// ---------------------------------------------------------------------------

const List<({String value, String label})> keyFigures = [
  (value: '10+', label: 'années d\'expérience'),
  (value: '150+', label: 'chantiers livrés'),
  (value: '60', label: 'collaborateurs'),
  (value: '98 %', label: 'délais respectés'),
];

// ---------------------------------------------------------------------------
// Engagements, étapes, FAQ
// ---------------------------------------------------------------------------

const List<({String icon, String title, String text})> commitments = [
  (icon: 'shield', title: 'Sécurité sur chantier', text: 'Équipements de protection, chantiers balisés et personnel formé.'),
  (icon: 'clock', title: 'Délais tenus', text: 'Un planning détaillé dès le devis et un point d\'avancement chaque semaine.'),
  (icon: 'check', title: 'Qualité contrôlée', text: 'Matériaux contrôlés et réception par étape, avant de passer à la suivante.'),
  (icon: 'file', title: 'Devis transparent', text: 'Un devis poste par poste, sans coût caché, et des avenants écrits.'),
];

const List<({String title, String text})> processSteps = [
  (title: 'Échange', text: 'Vous nous présentez votre projet, votre terrain et votre budget.'),
  (title: 'Étude & devis', text: 'Nous établissons plans, métrés et un devis détaillé sous 7 jours.'),
  (title: 'Chantier', text: 'Un conducteur de travaux dédié pilote l\'exécution et vous informe.'),
  (title: 'Livraison', text: 'Réception contradictoire, levée des réserves et remise des clés.'),
];

const List<({String q, String a})> faqs = [
  (
    q: 'Combien de temps faut-il pour obtenir un devis ?',
    a: 'Après la visite du site, nous remettons un devis détaillé sous 7 jours ouvrés en moyenne.',
  ),
  (
    q: 'Intervenez-vous en dehors de votre ville ?',
    a: 'Oui, nous intervenons sur l\'ensemble du territoire national, avec une base vie sur les chantiers éloignés.',
  ),
  (
    q: 'Pouvez-vous vous occuper du permis de construire ?',
    a: 'Oui : notre bureau d\'études prépare le dossier de permis de construire et en assure le suivi.',
  ),
  (
    q: 'Comment se déroule le paiement ?',
    a: 'Le paiement est échelonné selon l\'avancement des travaux, étape par étape, comme prévu au contrat.',
  ),
];

// ---------------------------------------------------------------------------
// Photos d'illustration (banque d'images Freepik / Magnific, licence gratuite)
// À REMPLACER de préférence par des photos de vos propres chantiers.
// ---------------------------------------------------------------------------

abstract final class Photos {
  static const hero = 'images/photos/chantier-structure.webp';
  static const engineer = 'images/photos/ingenieur-plans.webp';
  static const rebar = 'images/photos/ferraillage.webp';
  static const paving = 'images/photos/enrobe-route.webp';
}

/// Crédits exigés par la licence gratuite Freepik : affichés en pied de page.
const List<({String author, String url})> photoCredits = [
  (author: 'bearfotos', url: 'https://www.freepik.com/author/bearfotos'),
  (author: 'victor217', url: 'https://www.freepik.com/author/victor217'),
  (author: 'evening_tao', url: 'https://www.freepik.com/author/evening-tao'),
  (author: 'wirestock', url: 'https://www.freepik.com/author/wirestock'),
  (author: 'aleksandarlittlewolf', url: 'https://www.freepik.com/author/aleksandarlittlewolf'),
  (author: 'Oleksandr Ryzhkov', url: 'https://www.freepik.com/author/oleksandrryzhkov'),
  (author: '4045', url: 'https://www.freepik.com/author/4045'),
  (author: 'prostooleh', url: 'https://www.freepik.com/author/prostooleh'),
  (author: 'freestockcenter', url: 'https://www.freepik.com/author/freestockcenter'),
];
