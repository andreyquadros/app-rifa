import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rifa_flutter/view/screens/home_screen.dart';
import 'package:rifa_flutter/view/screens/webview_screen.dart';
import 'package:rifa_flutter/view/widgets/contato.dart';
import 'package:rifa_flutter/view/widgets/intro.dart';
import 'package:rifa_flutter/view/widgets/rifa.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/intro': (_) => IntroWidget(),
        '/rifa': (_) => RifaWidget(),
        '/contato': (_) => ContatoWidget(),
        WebViewScreen.routeName: (context) => WebViewScreen(),


      }));
}
