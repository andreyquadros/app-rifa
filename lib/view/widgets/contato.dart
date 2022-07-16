import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ContatoWidget extends StatelessWidget {
  const ContatoWidget({Key? key}) : super(key: key);

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
                onPressed: () {},
                icon: Icon(Icons.more_horiz_outlined),
                label: Text('Saiba mais'))
          ],
        ),
      ),
    );
  }
}
