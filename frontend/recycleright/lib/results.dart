import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycleright/config.dart';
import 'classification_result_card.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String classificationResult = "Loading...";
  Widget adviceWidget = const Text("Please wait, analyzing image.");

  @override
  void initState() {
    super.initState();
    uploadImage(widget.imagePath);
  }

  Future<void> uploadImage(String filePath) async {
    try {
      var uri = Uri.parse('${getServerBaseUrl()}/classify_image/');
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
        List<Widget> extraInfoWidgets = [];
        String itemName = result['text'];

        if ((classificationKeyword == 'donate' ||
                classificationKeyword == 'special') &&
            result['classification'].containsKey('locations')) {
          String prefixText = classificationKeyword == 'donate'
              ? "Google Link For Locations to Donate:"
              : "Google Link For Locations to Consider:";

          var links = [
            "https://www.google.com/search?q=where+to+drop+off+$itemName+in+Seattle"
          ];

          extraInfoWidgets.add(Text(prefixText,
              style: const TextStyle(fontWeight: FontWeight.bold)));

          extraInfoWidgets.addAll(links
              .map((link) => InkWell(
                    onTap: () => _launchURL(link),
                    child: Text(
                      link,
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ))
              .toList());
        } else {
          String adviceText = "Check item specifics for proper disposal.";
          if (classificationKeyword == 'recycle' &&
              result['classification'].containsKey('specifications')) {
            adviceText = result['classification']['specifications'].join('\n');
          } else if (classificationKeyword == 'garbage') {
            adviceText = "Please dispose of item in garbage.";
          } else if (classificationKeyword == 'compost') {
            adviceText = "Please compost item.";
          }

          extraInfoWidgets.add(Text(adviceText,
              style: const TextStyle(fontWeight: FontWeight.bold)));
        }

        Widget adviceWidget = extraInfoWidgets.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: extraInfoWidgets)
            : const Text("");

        setState(() {
          classificationResult = classificationKeyword;
          this.adviceWidget = adviceWidget;
        });
      } else {
        setState(() {
          classificationResult = "Failed to upload";
          adviceWidget = const Text(
              "LLM Server may be down. Please check your internet and try again.",
              style: TextStyle(fontWeight: FontWeight.bold));
        });
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        classificationResult = "Try Again";
        adviceWidget = const Text(
            "Object was not detected. Make sure object is in the frame with good lighting!",
            style: TextStyle(fontWeight: FontWeight.bold));
      });
      print(e.toString());
    }
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Results',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),        
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
                adviceWidget: adviceWidget,
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
