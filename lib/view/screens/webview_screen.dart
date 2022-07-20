import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rifa_flutter/view_model/ScreenArguments.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  //ScreenArguments telefone;

  WebViewScreen({Key? key}) : super(key: key);

  static const routeName = '/webview';


  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {



  Future<void> _abrirURL(String uri) async {
    print('o link é: ${uri}');
    final Uri _url = Uri.parse(uri);
    print(_url);
    

    if (!await launchUrl(_url)) {
      throw 'Não pode inicializar $_url';
    }else{
      await launchUrl(_url);
      print('é pentaaaaaaaaaaa!');
    }
  }

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments.toString ?? "";
    print(args.toString());

    print('ooooooooooooooooooooi');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("App Rifa - IFRO"),
      ),
      body: WebView(
        initialUrl: "https://api.whatsapp.com/send/?phone=5569993485858",
        javascriptMode: JavascriptMode.disabled,
        navigationDelegate: (NavigationRequest request) async {
          if (request.url
              .startsWith('https://api.whatsapp.com/send/?phone=')) {
            print('blocking navigation to $request}');
            List<String> urlSplitted = request.url.split("&text=");

            String phone = '5569993485858';
            String message =
            urlSplitted.last.toString().replaceAll("%20", " ");

            await _abrirURL(
                "${Uri.parse(message)}");
            return NavigationDecision.prevent;
          }

          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },

      )
    );
  }

}
