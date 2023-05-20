import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rifa_flutter/model/VendedoresMock.dart';
import 'package:rifa_flutter/model/class/Comprador.dart';
import 'package:url_launcher/url_launcher.dart';

enum Share {
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
}

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

  VendedoresMock _vendedoresMock = VendedoresMock.Vendedor;
  String vendedorFinal = 'Vendedor(a)';

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();

  void _limparControladores() {
    _nomeController.clear();
    _telefoneController.clear();
    _enderecoController.clear();
  }

  String? _validarNome(String? value) {
    if (value?.isEmpty ?? false) {
      const snackBar = SnackBar(
        content: Text(
            'Por favor preencha o campo Nome e Telefone, eles são obrigatórios!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      const snackBar = SnackBar(
        content: Text(
            'Utilize apenas letras do alfabeto, sem caracteres especiais e também não deixe vazio!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }

  void _salvarFirebase() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String _nomeC = _nomeController.text;
    String _telefoneC = _telefoneController.text;
    String _enderecoC = _enderecoController.text;

    Comprador _comprador = Comprador(
        nome: _nomeC,
        telefone: _telefoneC,
        endereco: _enderecoC,
        vendedor: vendedorFinal);
    await db
        .collection("compradores")
        .add(_comprador.toMap())
        .then((DocumentReference doc) {
      gerarPdf(doc.id, _nomeC, _telefoneC, _enderecoC, vendedorFinal);
      return print(doc.id);
    });

    const snackBar = SnackBar(
      content: Text('Executado com sucesso!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> gerarPdf(String doc, String nome, String telefone,
      String endereco, String vendedor) async {
    final font = await rootBundle.load("fonts/open-sans.ttf");
    final ttf = pw.Font.ttf(font);

    //final pdf = pw.Document();
    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttf)),
        build: (context) {
          return [
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                [
                  'Nome',
                  'Telefone',
                  'Endereço',
                  'Qual a sala fez a venda?',
                  'Hash Identificador'
                ],
                [
                  '${nome}',
                  '${telefone}',
                  '${endereco}',
                  '${vendedor}',
                  '${doc}'
                ]
              ],
            ),
          ];
        }));

    final output = await getExternalStorageDirectory();
    final file = File('${output?.path}/rifa-${doc}.pdf');
    await file.writeAsBytes(await pdf.save());
    print(output?.path);
    print('PDF SALVO COM SUCESSO!');
    if (output != null) {
      await OpenFile.open('${output.path}/rifa-${doc}.pdf');
    }
    //await enviarWhatsApp(file, output, telefone);
    print('PDF ABERTO COM SUCESSO!!');
    _limparControladores();
  }

  @override
  void initState() {
    _databaseFB;
  }

  Future<void> _databaseFB() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "Api key here",
        appId: "App id here",
        messagingSenderId: "Messaging sender id here",
        projectId: "project id here",
      ),
    );
  }

  _launchWhatsapp(String telefone, String comprador) async {
    var whatsapp_number = "+55${telefone}";
    var whatsappAndroid = Uri.parse(
        "whatsapp://send?phone=$whatsapp_number&text=Olá, ${comprador}! Tudo bem?! Vou enviar seu comprovante de compra de rifa! Obrigado por ajudar o IFRO Campus Ariquemes!");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp não está instalado!"),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 15, 32, 32),
          child: Column(
            children: [
              _buildVendorSelector(),
              TextFormField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person),
                  hintText: 'Qual o seu nome?',
                  labelText: 'Nome do Comprador*',
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
                  labelText: 'Número de Telefone - Ex: 69993485858 *',
                  prefixText: '+55 ',
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
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    _validarNome(_nomeController.text);
                    if (_telefoneController.text.isNotEmpty)
                      _launchWhatsapp(
                          _telefoneController.text, _nomeController.text);
                  },
                  icon: Icon(Icons.wifi_calling_3),
                  label: Text('Abrir contato no WhatsApp')),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    _validarNome(_nomeController.text);
                    if (_nomeController.text.isNotEmpty) _salvarFirebase();
                  },
                  icon: Icon(Icons.sell),
                  label: Text(
                    'Gerar Rifa',
                  )),
              const SizedBox(height: 40.0),
              Text(
                  'Primeiro envie uma mensagem para o contato e depois gere a Rifa.')
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendorSelector() {
    final dropdown = DropdownButton<VendedoresMock>(
      value: _vendedoresMock,
      onChanged: (novoVendedor) {
        vendedorFinal = novoVendedor.toString();

        if (novoVendedor != null)
          setState(() => _vendedoresMock = novoVendedor);
      },
      items: [
        for (final vendedor in VendedoresMock.values)
          DropdownMenuItem(
            value: vendedor,
            child: Text(vendedor.name),
          )
      ],
    );
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      title: const Text('Quem fez a venda:'),
      subtitle: dropdown,
    );
  }
}
