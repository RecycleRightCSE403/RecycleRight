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
      var uri = Uri.parse('http://10.0.2.2:8000/uploadfile/');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          filePath,
          contentType: MediaType('image', 'jpeg'),
        ));
      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          classificationResult = "Recycle"; // default for now (maybe for demo)
          advice =
              "Thank you for recycling!";
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
        classificationResult = "Error";
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
              if (classificationResult !=
                  "Loading...") // just in case
                ClassificationResultCard(
                  category: classificationResult,
                  advice: advice,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              if (classificationResult ==
                  "Loading...") // just in case
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
