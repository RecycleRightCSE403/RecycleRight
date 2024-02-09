import 'package:flutter/material.dart';
import 'dart:io';
import 'classification_result_card.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Example for now
    String classificationResult = "Recycle";
    String advice = "This item can be recycled!";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Results'),
        centerTitle: true, 
      ),
      body: Center(
        // Center entire content vertically and horizontally
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // some padding
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10.0),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              ClassificationResultCard(
                category: classificationResult,
                advice: advice,
                crossAxisAlignment: CrossAxisAlignment.center,
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
