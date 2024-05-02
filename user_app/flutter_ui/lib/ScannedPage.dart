import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ScannedPage extends StatelessWidget {
  final String barcode;
  final String shopName;
  const ScannedPage({Key? key, required this.barcode, required this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dio Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(barcode: barcode, shopName: shopName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String barcode;
  final String shopName;
  const MyHomePage({Key? key, required this.barcode, required this.shopName}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _pavadinimas = '';
  String _kaina = '';
  String _kategorija = '';
  String _sudetis = '';
  String _maistingumas = '';
  String _pagaminimoData = '';
  String _galiojimoPabaigosData = '';
  String _gamintojoPavadinimas = '';
  String _kilmesSalis = '';

  Future<void> fetchData() async {
    try {
      Response response = await Dio().get("http://192.168.0.103:8080/get_product?shop_name=${widget.shopName}&barcode=${widget.barcode}");
      Map<String, dynamic> data = jsonDecode(response.data);

      setState(() {
        _pavadinimas = data['pavadinimas'];
        _kaina = data['kaina'];
        _kategorija = data['kategorija'];
        _sudetis = data['sudetis'];
        _maistingumas = data['maistingumas'];
        _pagaminimoData = data['pagaminimo_data'];
        _galiojimoPabaigosData = data['galiojimo_pabaigos_data'];
        _gamintojoPavadinimas = data['gamintojo_pavadinimas'];
        _kilmesSalis = data['kilmes_salis'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pavadinimas: $_pavadinimas',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Kaina: $_kaina',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Kategorija: $_kategorija',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Sudėtis: $_sudetis',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Maistingumas: $_maistingumas',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Pagaminimo data: $_pagaminimoData',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Galiojimo pabaigos data: $_galiojimoPabaigosData',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Gamintojo pavadinimas: $_gamintojoPavadinimas',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Kilmės šalis: $_kilmesSalis',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
