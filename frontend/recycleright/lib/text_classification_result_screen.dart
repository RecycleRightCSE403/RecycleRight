import 'package:flutter/material.dart';

// `TextClassificationResultScreen` is a StatelessWidget that presents the user's text input
// and its corresponding classification result.
//
// This screen is used to display the outcome of a classification process, showing both the
// original text input by the user and the classification result returned by the system.
class TextClassificationResultScreen extends StatelessWidget {
  // The text input provided by the user for classification.
  final String userInput;

  // The classification result of the user's text input.
  final String classificationResult;

  // Constructs a `TextClassificationResultScreen` widget.
  //
  // Requires [userInput] to display the text that was classified and [classificationResult]
  // to display the outcome of the classification process.
  const TextClassificationResultScreen({
    Key? key,
    required this.userInput,
    required this.classificationResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the high-level structure for the results screen.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Results'), // Title of the AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the body content for aesthetics.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start of the screen.
          children: [
            const Text(
              'Your Input:', // Label for the user's input section.
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Spacing between label and user input text.
            Text(
              userInput, // Displays the user's text input.
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16), // Spacing between sections.
            const Text(
              'Classification:', // Label for the classification result section.
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Spacing between label and classification result text.
            Text(
              classificationResult, // Displays the classification result.
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
