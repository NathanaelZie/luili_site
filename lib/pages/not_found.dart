import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jx_cli/ui.dart';

import '../components/sections.dart';

class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    context.setStatusCode(404);
    return section(classes: 'bg:stone', [
      seo(title: 'Page introuvable', description: 'Cette page n\'existe pas ou a été déplacée.'),
      container(classes: 'py:[7rem] ta:center flex fd:column ai:center gap:4', [
        p(classes: 'fs:6xl fw:extrabold c:brand', [.text('404')]),
        h1(classes: 'fs:3xl fw:extrabold c:ink', [.text('Page introuvable')]),
        p(classes: 'c:gray-500 mw:[30rem]', [.text('La page que vous cherchez n\'existe pas ou a été déplacée.')]),
        JxButton([.text('Retour à l\'accueil')], href: '/', classes: 'mt:4 bg:brand! hover:bg:brandd!'),
      ]),
    ]);
  }
}
