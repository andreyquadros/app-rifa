import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatoWidget extends StatefulWidget {
  const ContatoWidget({Key? key}) : super(key: key);

  @override
  State<ContatoWidget> createState() => _ContatoWidgetState();
}

class _ContatoWidgetState extends State<ContatoWidget> {

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {

    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  final Uri _url = Uri.parse('https://www.instagram.com/quanyx.softhouse');

  Future<void> _abrirURL() async {
    if (!await launchUrl(_url)) {
      throw 'Não pode inicializar $_url';
    }
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 250,
              child: Image.asset('images/logo-quanyx.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 10),
              child: AutoSizeText(
                '''A Quanyx é uma SoftHouse, empresa de desenvolvimento de Sistemas e Aplicativos, '''
                '''que tem como objetivo Resgatar a Identidade das Pessoas através de Princípios, Tecnologia e Inovação.'''
                ''' Localizada em Ariquemes - Rondônia. ''',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.justify,
                minFontSize: 18,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton.icon(
                onPressed: _abrirURL,
                icon: Icon(Icons.more_horiz_outlined),
                label: Text('Saiba mais')),

          ],
        ),
      ),
    );
  }
}
