import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromARGB(255, 2, 72, 113), // Deep Ocean Blue
  colorScheme: ColorScheme.light(
    primary: Color.fromARGB(245, 4, 59, 91), // Deep Ocean Blue
    onPrimary: Colors.white, // White text/icons on primary color
    secondary: const Color.fromARGB(255, 129, 212, 250), // Sky Blue
    onSecondary: Colors.black, // Black text/icons on secondary color
    background: const Color.fromARGB(255, 236, 239, 241), // Soft Blue-Grey
    onBackground: Colors.black, // Black text/icons on background color
    surface: const Color.fromARGB(255, 255, 255, 255), // White surface
    onSurface: Colors.black, // Black text/icons on surface color
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(245, 4, 59, 91), // Deep Ocean Blue
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20, // Adjusted for better readability
      fontWeight: FontWeight.bold,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(245, 4, 59, 91), // Sky Blue
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: const Color.fromARGB(255, 2, 119, 189), // Deep Ocean Blue text
    ),
  ),

  useMaterial3: true,
);
