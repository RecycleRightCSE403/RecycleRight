import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycleright/config.dart';
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
      var uri = Uri.parse('${getServerBaseUrl()}/classify_image/');
      print("Posting request to $uri");
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
        print("Decoded JSON response: $result");

        String classificationKeyword =
            result['classification']['classification'].toString().trim();
        List<dynamic> extraInfo = [];

        if (classificationKeyword == 'recycle' &&
            result['classification'].containsKey('specifications')) {
          extraInfo = result['classification']['specifications'];
        } else if ((classificationKeyword == 'donate' ||
                classificationKeyword == 'special') &&
            result['classification'].containsKey('locations')) {
          extraInfo = result['classification']['locations'];
        }

        String extraInfoText = extraInfo.join('\n');

        setState(() {
          classificationResult = classificationKeyword;
          advice = extraInfo.isNotEmpty
              ? extraInfoText
              : "Check item specifics for proper disposal.";
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
        classificationResult = "Try Again";
        advice = "Object was not detected. Make sure object is in the frame with good lighting!";
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
              ClassificationResultCard(
                category: classificationResult,
                advice: advice, adviceWidget: Text(advice), 
              ),
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
