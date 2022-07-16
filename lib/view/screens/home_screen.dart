import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:rifa_flutter/model/VendedoresMock.dart';
import 'package:rifa_flutter/view/widgets/contato.dart';
import 'package:rifa_flutter/view/widgets/intro.dart';
import 'package:rifa_flutter/view/widgets/rifa.dart';

const _kPages = <String, IconData >{
  'Apresentação': Icons.app_registration,
  'Rifa': Icons.add_shopping_cart,
  'Contato': Icons.contact_page_rounded,
};


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabStyle _tabStyle = TabStyle.reactCircle;
  VendedoresMock _vendedoresMock = VendedoresMock.Andrey;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("App Rifa - IFRO"),
        ),
        body: Column(
          children: [
            _buildVendorSelector(),
            const Divider(),
            const Expanded(
              child: TabBarView(
                children: [
                  IntroWidget(),
                  RifaWidget(),
                  ContatoWidget(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.green,
          color: Colors.white,
          style: _tabStyle,
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorSelector() {
    final dropdown = DropdownButton<VendedoresMock>(
      value: _vendedoresMock,
      onChanged: (novoVendedor) {
        if (novoVendedor != null) setState(() => _vendedoresMock = novoVendedor);
      },
      items: [
        for (final vendedor in VendedoresMock.values)
          DropdownMenuItem(
            value: vendedor,
            child: Text(vendedor.toString()),
          )
      ],
    );
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      title: const Text('Vendedor(a) :'),
      trailing: dropdown,
    );
  }
}