import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'classification_result_card.dart';
import 'package:http_parser/http_parser.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String classificationResult = "Loading...";
  String advice = "Please wait, analyzing image.";

  @override
  void initState() {
    super.initState();
    uploadImage(widget.imagePath);
  }

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
