import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycleright/config.dart';
import 'dart:convert';
import 'classification_result_card.dart';

class TextClassificationResultScreen extends StatefulWidget {
  final String userInput;

  const TextClassificationResultScreen({Key? key, required this.userInput, required String classificationResult})
      : super(key: key);

  @override
  State<TextClassificationResultScreen> createState() =>
      _TextClassificationResultScreenState();
}

class _TextClassificationResultScreenState
    extends State<TextClassificationResultScreen> {
  String classificationResult = "Loading...";
  String advice = "Please wait, analyzing text.";

  @override
  void initState() {
    super.initState();
    classifyText(widget.userInput);
  }

  Future<void> classifyText(String text) async {
    var uri = Uri.parse('${getServerBaseUrl()}/classify_text/');
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print("Decoded JSON response: $result");

      String classificationKeyword =
          result['classification']['classification'].toString().trim();
      List<dynamic> extraInfo = [];
      String prefixText = "";

      if (classificationKeyword == 'recycle' &&
          result['classification'].containsKey('specifications')) {
        extraInfo = result['classification']['specifications'];
      } else if (classificationKeyword == 'donate' &&
          result['classification'].containsKey('locations')) {
        extraInfo = result['classification']['locations'];
        prefixText = "Locations to Donate Near You:";
      } else if (classificationKeyword == 'special' &&
          result['classification'].containsKey('locations')) {
        extraInfo = result['classification']['locations'];
        prefixText = "Locations to Consider Near You:";
      }

      String extraInfoText = extraInfo.isNotEmpty
          ? "$prefixText\n${extraInfo.join('\n')}"
          : "";

      setState(() {
        classificationResult = classificationKeyword;
        advice = extraInfoText;
      });
    } else {
      setState(() {
        classificationResult = "Error";
        advice = "Failed to classify text. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Results',
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
              const SizedBox(height: 25.0),
              ClassificationResultCard(
                category: classificationResult,
                advice: advice, adviceWidget: Text(advice),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
