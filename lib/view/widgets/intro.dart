import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 250,
            child: Image.asset('images/logo.png'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: AutoSizeText(
              '''O Instituto Federal de Rondônia Campus Ariquemes preconizando o princípio da economicidade e '''
              '''seguindo INSTRUÇÃO NORMATIVA Nº 1, DE 15 DE DEZEMBRO DE 2020, que orienta sobre a não utilização de papel, desenvolveu esse Aplicativo com o intuito'''
              ''' de atender a demanda de venda de Rifas para a Festa Junina da Instituição, com o objetivo de ZERAR o uso de papel impresso. ''',

              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.justify,
              minFontSize: 18,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
