import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'results.dart';
import 'text_classification_result_screen.dart';
import 'about_page.dart';

// The `MyHomePage` widget serves as the primary screen of the RecycleRight app,
// showcasing the main functionalities such as real-time camera preview for item classification,
// a search feature for manual item lookup, and a navigation drawer for additional options.
//
// This StatefulWidget manages the camera initialization and user interactions to navigate
// through different sections of the app or perform item classifications.
class MyHomePage extends StatefulWidget {
  // A [CameraDescription] object to handle the camera's details like the lens direction.
  final CameraDescription camera;

  // The title of the home page, displayed in the AppBar.
  final String title;

  // Creates an instance of `MyHomePage`.
  //
  // Requires a [CameraDescription] to work with the device's camera and a title
  // for the AppBar.
  const MyHomePage({super.key, required this.camera, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller; // Manages camera state for preview and captures.
  late Future<void> _initializeControllerFuture; // Ensures camera initialization before use.
  final TextEditingController _textEditingController = TextEditingController(); // Manages text input for the search bar.

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller with medium resolution.
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize(); // Begin camera initialization.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the widget tree.
    _controller.dispose();
    _textEditingController.dispose(); // Clear the controller resources.
    super.dispose();
  }

  // Captures an image using the camera controller and navigates to the DisplayPictureScreen.
  //
  // This method is triggered upon a tap gesture on the camera preview or the floating
  // action button. It ensures that the camera is initialized before attempting to take
  // a picture. If successful, it navigates to a screen displaying the captured image.
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
    // Scaffold provides the structural layout for the home page.
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            // Customized text styling for the app title.
            style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontFamily: 'Inter',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xffEDEAD0),
            ) ?? const TextStyle(
              fontFamily: 'Inter',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xffEDEAD0),
            ),
            children: const [
              TextSpan(text: 'Recycle'),
              TextSpan(text: 'Right'),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0, // Removes the AppBar's shadow for a flat design.
      ),

      drawer: Drawer(
        // A navigation drawer for additional navigation options within the app.
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
                  fontSize: 30,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ListTile(
              // Navigates to the About Us page upon tapping.
              leading: Icon(Icons.info_outline),
              title: Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ));
              },
            ),
            // Additional ListTiles can be added here for more navigation options.
          ],
        ),
      ),

      body: Column(
        // The main body of the home page, including a search bar and camera preview.
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // A text field for manual item lookup through textual search.
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Search trash/objects...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onSubmitted: (value) {
                // Navigate to the classification result screen upon submitting a search.
                if (value.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TextClassificationResultScreen(
                        userInput: value,
                        classificationResult: 'Classification Pending',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            // Displays camera preview for real-time classification.
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: takePicture,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_controller), // Real-time camera preview.
                        Icon(Icons.camera_alt, size: 64, color: Colors.white), // Camera icon overlay.
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator()); // Loading indicator while the camera initializes.
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // A floating action button to take pictures.
        onPressed: takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
