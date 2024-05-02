import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_ui/ScannedPage.dart';

class ShopList extends StatefulWidget {
  ShopList({Key? key}) : super(key: key);

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State with WidgetsBindingObserver {
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _requestCameraPermission(); // Request camera permission when the widget is initialized
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _requestCameraPermission(); // Request camera permission when the app is resumed
    }
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        // You may want to show an alert or message to the user here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: const Text(
              'Parduotuvės',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 48),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 'button1',
                  child: Text('Button 1'),
                ),
                const PopupMenuItem(
                  value: 'button2',
                  child: Text('Button 2'),
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection
              },
            ),
          ],
        ),
        body: FutureBuilder<Response>(
          future: _dio.get('http://192.168.0.103:8080/shop_list'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<dynamic> dataList =
                  json.decode(snapshot.data?.data ?? '');
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double halfScreenWidth = constraints.maxWidth / 2;
                  return Column(
                    children: _buildRows(context, halfScreenWidth, dataList),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildRows(
      BuildContext context, double halfScreenWidth, List<dynamic> dataList) {
    List<Widget> rows = [];
    for (int i = 0; i < dataList.length; i += 2) {
      if (i + 1 < dataList.length) {
        rows.add(
          Row(
            children: [
              _buildShopWidget(context, halfScreenWidth, dataList[i]),
              _buildShopWidget(context, halfScreenWidth, dataList[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              _buildShopWidget(context, halfScreenWidth, dataList[i]),
              Expanded(child: Container()),
            ],
          ),
        );
      }
    }
    return rows;
  }

  Widget _buildShopWidget(
      BuildContext context, double halfScreenWidth, dynamic data) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Future<void> _scanBarcode() async {
            try {
              var result = await BarcodeScanner.scan();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScannedPage(barcode: result.rawContent, shopName: data['image']),
                ),
              );
            } catch (e) {
              print('Error scanning barcode: $e');
            }
          }

          _scanBarcode();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: halfScreenWidth,
              height: halfScreenWidth,
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<Response>(
                future: _dio.get(
                  'http://192.168.0.103:8080/get_image?image=${data['image']}',
                  options: Options(responseType: ResponseType.bytes),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final Uint8List imageData = snapshot.data!.data;
                    if (imageData.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Image.memory(
                            imageData,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return const FlutterLogo();
                    }
                  }
                },
              ),
            ),
            Text(
              "${data['name']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
