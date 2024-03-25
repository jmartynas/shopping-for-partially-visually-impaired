import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class shopList extends StatelessWidget {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shop List'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: Text('Button 1'),
                  value: 'button1',
                ),
                PopupMenuItem(
                  child: Text('Button 2'),
                  value: 'button2',
                ),
              ],
              onSelected: (value) {
                // Handle menu item selection
              },
            ),
          ],
        ),
        body: FutureBuilder<Response>(
          future: _dio.get('http://127.0.0.1:8080/shop_list'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<dynamic> dataList = json.decode(snapshot.data?.data ?? '');
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

  List<Widget> _buildRows(BuildContext context, double halfScreenWidth, List<dynamic> dataList) {
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
        // Handle the case when there is only one shop left in a row
        rows.add(
          Row(
            children: [
              _buildShopWidget(context, halfScreenWidth, dataList[i]),
              Expanded(child: Container()), // Placeholder to center the last shop with the first column
            ],
          ),
        );
      }
    }
    return rows;
  }

  Widget _buildShopWidget(BuildContext context, double halfScreenWidth, dynamic data) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        // Handle tap event, for example navigate to another page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
        print("Shop ${data['name']} clicked");
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: halfScreenWidth,
            height: halfScreenWidth,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder<Response>(
              future: _dio.get(
                'http://127.0.0.1:8080/get_image?image=${data['image']}',
                options: Options(responseType: ResponseType.bytes), // Specify response type
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final Uint8List imageData = snapshot.data!.data;
                  if (imageData.isNotEmpty) {
                    return Image.memory(imageData, fit: BoxFit.cover);
                  } else {
                    return FlutterLogo(); // Fallback if image not available
                  }
                }
              },
            ),
          ),
          Text("${data['name']}"),
        ],
      ),
    ),
  );
}
}

