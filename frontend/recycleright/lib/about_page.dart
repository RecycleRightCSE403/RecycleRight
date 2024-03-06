import 'package:flutter/material.dart';

// `AboutPage` is a stateless widget that displays information about the RecycleRight app,
// including its purpose, features, and the development team. This page is intended to
// provide users with an understanding of how the app can help them with proper waste disposal
// and to acknowledge the team behind the app.
//
// The page uses a simple and informative layout to present its content, making it easy for users
// to read and understand the app's goals and functionalities.
class AboutPage extends StatelessWidget {
  // Constructs the `AboutPage` widget.
  //
  // Takes an optional [Key] as a parameter to initialize the widget's key.
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the high-level structure for the About page.
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true, // Centers the title in the app bar.
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Adds padding around the content for better readability.
        child: SingleChildScrollView(
          // Allows the content to be scrollable, ensuring it's accessible on devices with small screens.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start of the axis.
            children: [
              // Introduction text with application name and purpose.
              Text(
                'Welcome to RecycleRight',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Adds space between paragraphs.
              // Detailed description of the app's functionality and purpose.
              Text(
                'RecycleRight is designed to make recycling and proper waste disposal easier than ever! Simply point your camera at an item, and our app will tell you whether to recycle, compost, dispose of as garbage, or handle as a special item.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Highlights the main features of the app.
              Text(
                'Features Include:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Lists features for quick reference.
              Text(
                '- Instant classification of items into recycle, compost, garbage, or special disposal categories.\n'
                '- Search functionality for quick item lookup.\n'
                '- User-friendly interface for easy navigation.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Closing statement that emphasizes the community impact of using the app.
              Text(
                'Together, we can make a difference in our community by disposing of waste responsibly. Thank you for using RecycleRight!',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Introduction to the development team.
              Text(
                'Meet the Developers:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Lists the team members and their roles.
              Text(
                'Team Member             Role(s)\n'
                '------------------------------------\n'
                'Aaron Jenson               ML / CV\n'
                'Victor Jou                     CV / Backend\n'
                'Aneesha Ramesh         Backend / CV\n'
                'Sulaiman Shahbain      Front End / UI\n'
                'Julia Tawfik                   Front End / UI',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

