import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rifa_flutter/model/VendedoresMock.dart';
import 'package:rifa_flutter/model/class/Comprador.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import 'package:pdf/widgets.dart' as pw;

import '../../firebase_options.dart';

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
  //int? n_rifa;

  VendedoresMock _vendedoresMock = VendedoresMock.SALA_3A_AGRO;
  String vendedorFinal = 'SALA_3A_AGRO';

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

  void _salvarFirebase() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String _nomeC  = _nomeController.text;
    String _telefoneC = _telefoneController.text;
    String _enderecoC = _enderecoController.text;



    Comprador _comprador = Comprador(nome:_nomeC, telefone: _telefoneC, endereco: _enderecoC, vendedor: vendedorFinal );
    await db.collection("compradores").add(_comprador.toMap()).then((DocumentReference doc) {
      gerarPdf(doc.id, _nomeC, _telefoneC, _enderecoC, vendedorFinal);
      return print(doc.id);
    });

    const snackBar = SnackBar(
      content: Text('Executado com sucesso!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  Future<void> gerarPdf(String doc, String nome, String telefone, String endereco, String vendedor) async {
    final font = await rootBundle.load("fonts/open-sans.ttf");
    final ttf = pw.Font.ttf(font);

    //final pdf = pw.Document();
    final pw.Document pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttf) ),
        build: (context) {
      return [
      pw.Table.fromTextArray(context: context, data:  <List<String>>[
        ['Nome' , 'Telefone' , 'Endereço' , 'Qual a sala fez a venda?' , 'Hash Identificador'],
        ['${nome}' , '${telefone}' , '${endereco}' , '${vendedor}' , '${doc}']
      ],
      ),
    ];
    }));
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Center(
    //       child: pw.Text('PDF GERADO DOC = ${doc}', style: pw.TextStyle(font: ttf) ),
    //     ),
    //   ),
    // );
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/rifa-${doc}.pdf');
      await file.writeAsBytes(await pdf.save());
      print(output.path);
      print('PDF SALVO COM SUCESSO!');
      enviarWhatsApp(file, output, telefone);
      print('COMPARTILHADO NO WHATSAPP SUCESSO!');

  }

  Future<void> enviarWhatsApp(File file, Directory output, String telefone) async {
    Future<void> isInstalled() async {
      final val = await WhatsappShare.isInstalled(
          package: Package.whatsapp
      );
      print('Whatsapp está instalado: $val');
      await WhatsappShare.shareFile(
        phone: telefone,
        filePath: [file.toString()],
      );
    }

  }

  // Future<void> lerPDF() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/text_file.txt');
  //   } catch (e) {
  //     print('exception');
  //   }
  // }


  // @override
  // void dispose(){
  //   _nomeController.dispose();
  //   _telefoneController.dispose();
  //   _enderecoController.dispose();
  // }

  @override
  void initState(){
    _databaseFB;
  }
  Future <void> _databaseFB() async{
    final database = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              _buildVendorSelector(),
              const SizedBox(height: 24.0),
              Divider(),
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
                  onPressed: (){ _salvarFirebase();},
                  icon: Icon(Icons.sell),
                  label: Text('Gerar Rifa',)),
              const SizedBox(height: 20.0),
              // ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //         primary: Colors.green,
              //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //         textStyle: TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold)),
              //     onPressed: () {},
              //     icon: Icon(Icons.whatsapp),
              //     label: Text('Enviar WhatsApp')),
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

        if (novoVendedor != null) setState(() => _vendedoresMock = novoVendedor);
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
      title: const Text('Sala que fez a venda:'),
      trailing: dropdown,
    );
  }
}
