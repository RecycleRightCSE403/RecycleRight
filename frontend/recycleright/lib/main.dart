import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_page.dart';
import 'theme.dart'; // Custom theme for the app.

// The main entry point of the RecycleRight application.
//
// This file is responsible for initializing the app, including fetching available
// camera devices and setting up the theme. It defines the `MyApp` widget, which sets
// up the MaterialApp and the initial route/home screen of the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that plugin services are initialized.
  final cameras = await availableCameras(); // Asynchronously gets a list of available cameras.
  final firstCamera = cameras.first; // Selects the first camera from the list.
  
  // Runs the app, passing the selected camera to the `MyApp` widget.
  runApp(MyApp(camera: firstCamera));
}

// `MyApp` is a StatelessWidget that represents the root of your application.
//
// It's responsible for creating the MaterialApp, which in turn sets up the
// navigation and theming for the app. The theme and the home page are defined here.
class MyApp extends StatelessWidget {
  // The camera description, which is passed down to widgets that require camera functionality.
  final CameraDescription camera;

  // Constructs the `MyApp` widget with a required [camera] parameter.
  //
  // The [camera] parameter is required to initialize and pass the camera functionality
  // to the screens that require it, such as the `MyHomePage`.
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Right', // The title of the app, used in the task switcher.
      theme: appTheme, // Apply the custom theme from `theme.dart` for app-wide styling.
      home: MyHomePage(camera: camera, title: 'RecycleRight'), // Sets the home page of the app.
    );
  }
}
