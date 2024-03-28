import 'package:flutter/material.dart';
import 'package:flutter_ui/ShopList.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized
  runApp(ShopList());
}
