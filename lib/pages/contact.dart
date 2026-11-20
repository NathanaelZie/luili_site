import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jx_cli/ui.dart';

import '../components/icons.dart';
import '../components/sections.dart';
import '../data/contact_rules.dart';
import '../data/site_data.dart';

/// Page contact. Le formulaire est un vrai `<form>` POST traité par le
/// serveur (/api/contact) : il fonctionne sans JavaScript.
class ContactPage extends StatelessComponent {
  const ContactPage({this.status, this.service, super.key});

  /// Résultat de l'envoi précédent (?statut=…), posé par le serveur.
  final String? status;

  /// Service présélectionné (?service=…), ignoré s'il est inconnu.
  final String? service;

  @override
  Component build(BuildContext context) {
    final selected = service != null && ContactRules.isValidSubject(service!) ? service : null;

    return div([
      seo(title: 'Contact & devis', description: 'Contactez ${Company.name} pour un devis gratuit de construction, rénovation ou travaux publics.'),
      pageHero(
        title: 'Contact & devis gratuit',
        subtitle: 'Décrivez votre projet : nous vous répondons sous 48 heures ouvrées.',
        breadcrumbs: const [(label: 'Accueil', href: '/'), (label: 'Contact', href: null)],
      ),
      section(classes: 'bg:stone py:[5rem]', [
        container(classes: 'grid gap:10 lg:cols:3', [
          div(classes: 'flex fd:column gap:4', [
            _infoCard('phone', 'Téléphone', a(href: Company.phoneHref, classes: 'hover:c:brand', [.text(Company.phone)]), 0),
            _infoCard('mail', 'E-mail', a(href: 'mailto:${Company.email}', classes: 'hover:c:brand', [.text(Company.email)]), 1),
            _infoCard('pin', 'Adresse', .text(Company.address), 2),
            _infoCard('clock', 'Horaires', .text(Company.hours), 3),
          ]),
          div(classes: 'lg:span:2 smt:[9rem] br:2xl bg:white p:8 md:p:10 sh:md', attributes: {'id': 'formulaire', ...reveal(index: 1)}, [
            h2(classes: 'fs:2xl fw:extrabold c:ink', [.text('Parlez-nous de votre projet')]),
            p(classes: 'mt:2 c:gray-500', [.text('Les champs marqués d\'un astérisque sont obligatoires.')]),
            if (_statusAlert() case final alert?) div(classes: 'mt:6', [alert]),
            _form(selected),
          ]),
        ]),
      ]),
    ]);
  }

  Component? _statusAlert() {
    return switch (status) {
      'ok' => const JxAlert(
        tone: JxTone.success,
        title: 'Message envoyé',
        [.text('Merci ! Votre demande a bien été reçue. Nous vous recontactons rapidement.')],
      ),
      'invalide' => const JxAlert(
        tone: JxTone.danger,
        title: 'Formulaire incomplet',
        [.text('Vérifiez votre nom, votre e-mail et votre message (au moins 10 caractères), puis réessayez.')],
      ),
      'limite' => const JxAlert(
        tone: JxTone.warning,
        title: 'Trop de demandes',
        [.text('Vous avez déjà envoyé plusieurs messages. Merci de réessayer dans quelques minutes ou de nous appeler.')],
      ),
      'erreur' => const JxAlert(
        tone: JxTone.danger,
        title: 'Envoi impossible',
        [.text('Une erreur est survenue. Réessayez plus tard ou contactez-nous par téléphone.')],
      ),
      _ => null,
    };
  }

  Component _form(String? selected) {
    return form(
      action: '/api/contact',
      method: FormMethod.post,
      classes: 'mt:8 grid gap:5 md:cols:2',
      [
        _input(id: 'nom', label: 'Nom complet *', type: InputType.text, max: ContactRules.nameMax, required: true, autocomplete: 'name'),
        _input(id: 'telephone', label: 'Téléphone', type: InputType.tel, max: ContactRules.phoneMax, autocomplete: 'tel'),
        div(classes: 'md:span:2', [
          _input(id: 'email', label: 'E-mail *', type: InputType.email, max: ContactRules.emailMax, required: true, autocomplete: 'email'),
        ]),
        div(classes: 'md:span:2', [
          JxSelect(
            id: 'sujet',
            name: 'sujet',
            label: 'Type de projet',
            required: true,
            value: selected,
            placeholder: 'Choisissez…',
            options: ContactRules.subjects,
          ),
        ]),
        div(classes: 'md:span:2 flex fd:column gap:2', [
          label(htmlFor: 'message', classes: 'fs:sm fw:medium c:gray-700', [.text('Votre message *')]),
          textarea(
            id: 'message',
            name: 'message',
            rows: 6,
            required: true,
            classes: 'w:full br:md bw:1 bc:gray-300 px:3 py:2 fs:base focus:bc:brand focus:ring:2 focus:ringc:brandl ol:none',
            attributes: {
              'minlength': '${ContactRules.messageMin}',
              'maxlength': '${ContactRules.messageMax}',
              'placeholder': 'Nature des travaux, lieu, surface, délai souhaité…',
            },
            [],
          ),
        ]),
        // Champ piège, invisible pour les humains.
        div(classes: 'pos:absolute left:[-10000px] w:px h:px ov:hidden', attributes: {'aria-hidden': 'true'}, [
          label(htmlFor: ContactRules.honeypotField, [.text('Ne pas remplir')]),
          input(
            id: ContactRules.honeypotField,
            name: ContactRules.honeypotField,
            type: InputType.text,
            attributes: {'tabindex': '-1', 'autocomplete': 'off'},
          ),
        ]),
        div(classes: 'md:span:2 flex fd:column sm:fd:row sm:ai:center jc:between gap:4 mt:2', [
          p(classes: 'fs:xs c:gray-500 mw:[26rem]', [
            .text('Vos données servent uniquement à répondre à votre demande. Voir nos '),
            a(href: '/mentions-legales', classes: 'td:underline hover:c:brand', [.text('mentions légales')]),
            .text('.'),
          ]),
          JxButton([.text('Envoyer ma demande'), icon('arrow', classes: 'w:5 h:5')], type: ButtonType.submit, size: JxButtonSize.lg, classes: 'ws:nowrap bg:brand! hover:bg:brandd!'),
        ]),
      ],
    );
  }

  Component _input({
    required String id,
    required String label,
    required InputType type,
    required int max,
    bool required = false,
    String? autocomplete,
  }) {
    return div(classes: 'flex fd:column gap:2', [
      Component.element(tag: 'label', attributes: {'for': id}, classes: 'fs:sm fw:medium c:gray-700', children: [.text(label)]),
      input(
        id: id,
        name: id,
        type: type,
        classes: 'w:full br:md bw:1 bc:gray-300 px:3 py:2 fs:base focus:bc:brand focus:ring:2 focus:ringc:brandl ol:none',
        attributes: {
          'maxlength': '$max',
          if (required) 'required': '',
          'autocomplete': ?autocomplete,
        },
      ),
    ]);
  }

  Component _infoCard(String iconName, String title, Component value, int index) {
    return div(classes: 'flex ai:start gap:4 br:xl bg:white p:6 sh:sm hover:sh:md tr:all dur:300', attributes: reveal(anim: 'anim:slide-up adur:700!', index: index), [
      span(classes: 'w:12 h:12 br:lg bg:brand c:white flex ai:center jc:center shrink:0', [icon(iconName, classes: 'w:6 h:6')]),
      div([
        h3(classes: 'fs:sm fw:semibold c:gray-500 uppercase ls:[0.08em]', [.text(title)]),
        p(classes: 'mt:1 fw:semibold c:ink', [value]),
      ]),
    ]);
  }
}
