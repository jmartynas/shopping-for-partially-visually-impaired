import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui/ShopList.dart';

List<CameraDescription> cameras = [];

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Removes the back button in the app bar
      ),
      body: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackButtonWidget(),
              SizedBox(width: 10),
              Text(
                'Grįžti',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24, // Keičiamas teksto dydis
                ),
              ),
              Spacer(),
              MenuButtonWidget(),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: SriftoDydisButton(),
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded,
          color: Colors.black, size: 48), // Increased button size
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShopList()));
      },
    );
  }
}

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu,
          color: Colors.black, size: 48), // Increased button size
      onPressed: () {
        // Handle menu button press
      },
    );
  }
}

class SriftoDydisButton extends StatefulWidget {
  const SriftoDydisButton({Key? key}) : super(key: key);

  @override
  _SriftoDydisButtonState createState() => _SriftoDydisButtonState();
}

class _SriftoDydisButtonState extends State<SriftoDydisButton> {
  late String _selectedFontSize = '14';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 16), // Increased padding
        elevation: 2,
      ),
      child: PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          CheckedPopupMenuItem<String>(
            value: '14',
            checked: _selectedFontSize == '14',
            child: const Text('14',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
          CheckedPopupMenuItem<String>(
            value: '16',
            checked: _selectedFontSize == '16',
            child: const Text('16',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
          CheckedPopupMenuItem<String>(
            value: '18',
            checked: _selectedFontSize == '18',
            child: const Text('18',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
          CheckedPopupMenuItem<String>(
            value: '20',
            checked: _selectedFontSize == '20',
            child: const Text('20',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
          CheckedPopupMenuItem<String>(
            value: '22',
            checked: _selectedFontSize == '22',
            child: const Text('22',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
          CheckedPopupMenuItem<String>(
            value: '24',
            checked: _selectedFontSize == '24',
            child: const Text('24',
                style: TextStyle(fontSize: 24)), // Increased font size
          ),
        ],
        onSelected: (String value) {
          setState(() {
            _selectedFontSize = value;
          });
        },
        child: const Text(
          'Šrifto dydis',
          style: TextStyle(
              color: Colors.white, fontSize: 24), // Increased font size
        ),
      ),
    );
  }
}

@override
Future<Widget> build(BuildContext context) async {
  if (cameras.isEmpty) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('No cameras found'),
        ),
      ),
    );
  } else {
    cameras = await availableCameras();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:
              CameraScreen(cameras[0]), // Panaudojamas CameraScreen widget'as
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen(this.camera, {Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller), // Rodomas kameros vaizdas
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
