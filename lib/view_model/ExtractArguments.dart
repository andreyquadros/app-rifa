import 'package:flutter/material.dart';

import 'ScreenArguments.dart';

class ExtractArguments extends StatelessWidget {
  const ExtractArguments({Key? key}) : super(key: key);

  static const routeName = '/extractArguments';



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Container();
  }
}
