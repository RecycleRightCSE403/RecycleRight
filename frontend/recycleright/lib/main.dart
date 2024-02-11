import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Right',
      theme: appTheme,
      home: MyHomePage(camera: camera, title: 'RecycleRight'),
    );
  }
}
