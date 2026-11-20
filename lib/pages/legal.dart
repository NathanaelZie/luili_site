import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/sections.dart';
import '../data/site_data.dart';

// À REMPLACER : informations légales réelles (RCCM, IFU, hébergeur…).
class LegalPage extends StatelessComponent {
  const LegalPage({super.key});

  @override
  Component build(BuildContext context) {
    return div([
      seo(title: 'Mentions légales', description: 'Mentions légales et politique de confidentialité de ${Company.name}.'),
      pageHero(
        title: 'Mentions légales',
        subtitle: 'Informations sur l\'éditeur du site et le traitement de vos données.',
        breadcrumbs: const [(label: 'Accueil', href: '/'), (label: 'Mentions légales', href: null)],
      ),
      section(classes: 'bg:white py:[4rem]', [
        container(classes: 'mw:[48rem]! flex fd:column gap:8 c:gray-700 lh:relaxed', [
          _block('Éditeur du site', [
            '${Company.name} — ${Company.address}',
            'Téléphone : ${Company.phone} · E-mail : ${Company.email}',
            'Registre du commerce (RCCM) : à compléter · Identifiant fiscal (IFU) : à compléter',
          ]),
          _block('Hébergement', ['Hébergeur : à compléter.']),
          _block('Données personnelles', [
            'Les informations transmises via le formulaire de contact (nom, e-mail, téléphone, message) sont '
                'utilisées uniquement pour répondre à votre demande. Elles ne sont ni vendues ni cédées à des tiers.',
            'Elles sont conservées le temps nécessaire au traitement de votre demande, puis au maximum 3 ans '
                'en l\'absence de relation commerciale.',
            'Vous pouvez demander l\'accès, la rectification ou la suppression de vos données en écrivant à ${Company.email}.',
          ]),
          _block('Cookies', ['Ce site ne dépose aucun cookie de suivi ni de mesure d\'audience.']),
        ]),
      ]),
    ]);
  }

  Component _block(String title, List<String> paragraphs) {
    return div([
      h2(classes: 'fs:xl fw:bold c:ink mb:3', [.text(title)]),
      for (final t in paragraphs) p(classes: 'mb:2', [.text(t)]),
    ]);
  }
}
