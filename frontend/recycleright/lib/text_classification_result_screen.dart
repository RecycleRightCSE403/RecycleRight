import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycleright/config.dart';
import 'dart:convert';
import 'classification_result_card.dart';
import 'package:url_launcher/url_launcher.dart';

// `TextClassificationResultScreen` is a StatelessWidget that presents the user's text input
// and its corresponding classification result.
//
// This screen is used to display the outcome of a classification process, showing both the
// original text input by the user and the classification result returned by the system.
class TextClassificationResultScreen extends StatefulWidget {
  // The text input provided by the user for classification.
  final String userInput;

  const TextClassificationResultScreen(
      {Key? key, required this.userInput, required String classificationResult})
      : super(key: key);

  // Constructs a `TextClassificationResultScreen` widget.
  //
  // Requires [userInput] to display the text that was classified and [classificationResult]
  // to display the outcome of the classification process.
  @override
  State<TextClassificationResultScreen> createState() =>
      _TextClassificationResultScreenState();
}

class _TextClassificationResultScreenState
    extends State<TextClassificationResultScreen> {
  String classificationResult = "Loading...";
  Widget adviceWidget = const Text("Please wait, analyzing text.");

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
      // print("Decoded JSON response: $result");

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
                  child: Text(
                    link,
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () => _launchURL(link),
                ))
            .toList());
      } else {
        String adviceText;
        if (classificationKeyword == 'recycle' &&
            result['classification'].containsKey('specifications')) {
          adviceText = result['classification']['specifications'].join('\n');
        } else if (classificationKeyword == 'garbage') {
          adviceText = "Please dispose of item in garbage.";
        } else if (classificationKeyword == 'compost') {
          adviceText = "Please compost item.";
        } else {
          adviceText = "";
        }
        extraInfoWidgets.add(Text(adviceText,
            style: const TextStyle(fontWeight: FontWeight.bold)));
      }

      Widget adviceWidget = extraInfoWidgets.isNotEmpty
          ? Column(children: extraInfoWidgets)
          : const Text("");

      setState(() {
        classificationResult = classificationKeyword;
        this.adviceWidget = adviceWidget;
      });
    } else {
      setState(() {
        classificationResult = "Error";
        adviceWidget = const Text(
            "LLM Server may be down. Please check your internet and try again.",
            style: TextStyle(fontWeight: FontWeight.bold));
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the high-level structure for the results screen.
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
                adviceWidget: adviceWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
