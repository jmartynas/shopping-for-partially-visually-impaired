import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui/scanner.dart';

class ShopList extends StatelessWidget {
  final Dio _dio = Dio();
  ShopList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the back button in the app bar
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
	    child: const Text('Parduotuvės',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24, // Keičiamas teksto dydis
		fontWeight: FontWeight.bold,
              ),
	    ),
	  ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(
	      icon: const Icon(Icons.menu,
	        color: Colors.black, size: 48
	      ),
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
          future: _dio.get('http://127.0.0.1:8080/shop_list'),
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
      	cameraInit() async{
        	cameras = await availableCameras(); // Initialize cameras
	}
	cameraInit();
        // Handle tap event, for example navigate to another page
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainApp()));
        print("Shop ${data['name']} clicked");
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
                'http://127.0.0.1:8080/get_image?image=${data['image']}',
                options: Options(responseType: ResponseType.bytes), // Specify response type
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
                      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
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
                    return const FlutterLogo(); // Fallback if image not available
                  }
                }
              },
            ),
          ),
          Text("${data['name']}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24, // Keičiamas teksto dydis
                ),
	  ),
        ],
      ),
    ),
  );
}
}

