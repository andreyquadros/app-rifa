import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rifa_flutter/model/class/vendedor.dart';

class FirebaseServices {
  var dbFirestore = FirebaseFirestore.instance;

  Future<List<Vendedor>> getVendedores() async {
    var firebaseCollection = dbFirestore.collection('vendedores');
    List<Vendedor> _vendedores = [];

    var result =
        await firebaseCollection.orderBy('nome', descending: true).get();

    for (var vendedor in result.docs) {
      _vendedores.add(Vendedor(
        id: vendedor.reference.id.toString(),
        nome: vendedor['nome'],
      ));
    }
    _vendedores.sort((a, b) => a.nome.compareTo(b.nome));
    log(_vendedores.toString());
    return _vendedores;
  }
}
