import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'classification_result_card.dart';
import 'package:http_parser/http_parser.dart';
// `DisplayPictureScreen` is a StatefulWidget that displays the captured image,
// sends it to a server for classification, and shows the classification result
// and corresponding advice.
//
// It also allows users to provide feedback on the classification accuracy.
class DisplayPictureScreen extends StatefulWidget {
  // The path to the image file that will be displayed and classified.
  final String imagePath;

  // Constructs a `DisplayPictureScreen` widget.
  //
  // Requires an [imagePath] parameter that specifies the location of the image to be classified.
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // Stores the result of the image classification.
  String classificationResult = "Loading...";
  // Stores the advice to be displayed based on the classification result.
  String advice = "Please wait, analyzing image.";

  @override
  void initState() {
    super.initState();
    uploadImage(widget.imagePath);
  }

  // Uploads the image at [filePath] to a server for classification and updates
  // the state with the classification result and advice.
  //
  // It constructs a POST request with the image, sends it to a predetermined URI,
  // and parses the server's response to update the UI accordingly.
  Future<void> uploadImage(String filePath) async {
    try {
      var uri = Uri.parse('http://10.0.2.2:8000/classify_image/');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType('image', 'jpeg'),
        ));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var result = jsonDecode(responseBody);
        var classification = result['classification']
            .toString()
            .trim()
            .replaceAll(RegExp(r'[. ]+'),
                ''); 

        // Map the classification result to advice for the user.
        String tempAdvice;
        switch (classification) {
          case "Recycle":
            tempAdvice = "Please Recycle this!";
            break;
          case "Compost":
            tempAdvice = "Great! This is compostable.";
            break;
          case "Garbage":
            tempAdvice = "This should go to garbage.";
            break;
          case "Other":
            tempAdvice = "Please dispose of this item carefully.";
            break;
          case "Error": // If "Error" is a possible server response
            tempAdvice =
                "An error occurred, check the item's disposal instructions.";
            break;
          default:
            classification =
                "Error"; // Set classification to "Error" for unknown responses
            tempAdvice =
                "An error occurred, check the item's disposal instructions.";
        }
        setState(() {
          classificationResult = classification;
          advice = tempAdvice;
        });
      } else {
        setState(() {
          classificationResult = "Failed to upload";
          advice = "Please try again.";
        });
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        classificationResult = "Error"; // Use "Error" for exceptions
        advice = "An error occurred when uploading the image.";
      });
      print(e.toString());
    }
  }

  // Builds the UI to display the image, classification result, advice, and a feedback button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Results'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 25.0),
              if (classificationResult != "Loading...") // just in case
                ClassificationResultCard(
                  category: classificationResult,
                  advice: advice,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              if (classificationResult == "Loading...") // just in case
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  
}
