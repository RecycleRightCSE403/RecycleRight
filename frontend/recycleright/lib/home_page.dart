import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'results.dart';
import 'text_classification_result_screen.dart';
import 'about_page.dart'; // Make sure to import the AboutPage class

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;
  final String title;
  const MyHomePage({super.key, required this.camera, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose(); // Disposing controller
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!_controller.value.isInitialized) {
      print('Error: Pick a camera first.');
      return;
    }
    try {
      final image = await _controller.takePicture();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                      fontFamily: 'Sans Serif',
                    ) ??
                const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
            children: const [
              TextSpan(text: 'R', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'ecycle', style: TextStyle(color: Colors.black)),
              TextSpan(text: 'R', style: TextStyle(color: Colors.green)),
              TextSpan(text: 'ight', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ));
              },
            ),
            // Add other ListTile widgets for more navigation options as needed
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Search trash/objects...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                // When user submits text
                if (value.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TextClassificationResultScreen(
                        userInput: value,
                        classificationResult:
                            'Classification Pending', // Placeholder for now
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await takePicture();
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
