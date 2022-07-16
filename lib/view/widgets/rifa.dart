import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RifaWidget extends StatefulWidget {
  const RifaWidget({Key? key}) : super(key: key);

  @override
  State<RifaWidget> createState() => _RifaWidgetState();
}

class _RifaWidgetState extends State<RifaWidget> {
  @override

  String? _nome;
  String? _telefone;
  String? _endereco;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();

  String? _validarNome(String? value) {
    if (value?.isEmpty ?? false) {
      return 'O nome é obrigatório.';
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'Por favor utilize apenas letras do alfabeto, sem caracteres especiais.';
    }
    return null;
  }



   final db = FirebaseFirestore.instance;




  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person),
                  hintText: 'Qual o seu nome?',
                  labelText: 'Nome *',
                ),
                onSaved: (String? value) {
                  this._nome = value;
                  print('name=$_nome');
                },
                validator: _validarNome,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone),
                  hintText: 'Qual o seu número de celular?',
                  labelText: 'Número de Telefone *',
                  prefixText: '+55 (69) ',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {
                  this._telefone = value;
                  print('Telefone =$_telefone');
                },
                // TextInputFormatters are applied in sequence.
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.streetview),
                  hintText: 'Endereço',
                  helperText: 'Esse Campo é opcional',
                  labelText: 'Qual o seu Endereço completo?',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {},
                  icon: Icon(Icons.sell),
                  label: Text('Gerar Rifa'))
            ],
          ),
        ),
      ),
    );
  }
}
