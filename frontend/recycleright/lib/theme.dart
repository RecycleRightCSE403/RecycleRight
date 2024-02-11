import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 126, 94, 82),
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 126, 94, 82),
    onPrimary: Colors.white,
    secondary: Colors.green.shade600,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 126, 94, 82),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
  ),
  useMaterial3: true,
);
