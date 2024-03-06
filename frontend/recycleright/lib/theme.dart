import 'package:flutter/material.dart';

// `appTheme` is a `ThemeData` object that specifies the custom theme for the RecycleRight app.
//
// It defines the color scheme, typography, and component themes to provide a unified
// appearance throughout the app. The theme emphasizes environmental aesthetics with
// a palette centered around green and cream colors, reflecting the app's focus on recycling
// and sustainability.
final ThemeData appTheme = ThemeData(
  brightness: Brightness.light, // Overall brightness of the app theme.
  primaryColor: const Color(0xFF111D13), // Dark green color used primarily for the app header.

  // Defines the color scheme for different UI components based on the app's branding.
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF111D13), // Dark green for primary elements like buttons and links.
    onPrimary: Color(0xFFEDEAD0), // Neutral cream color for text/icons on primary elements.
    secondary: Color(0xFF8FB996), // Light green for secondary elements and accents.
    onSecondary: Colors.black, // Black text/icons on secondary elements.
    background: Color(0xFF8FB996), // Light green for general app backgrounds.
    onBackground: Colors.black, // Black text/icons on the background.
    surface: Color(0xFFFFFFFF), // White color for surfaces like cards and menus.
    onSurface: Colors.black, // Black text/icons on white surfaces.
  ),

  // Customizes the AppBar appearance to match the app's theme.
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF111D13), // Dark green for the AppBar background.
    titleTextStyle: TextStyle(
      color: Color(0xFFEDEAD0), // Neutral cream color for the AppBar title.
      fontSize: 24, // Size of the AppBar title text.
      fontWeight: FontWeight.bold, // Bold weight for the AppBar title.
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFEDEAD0), // Neutral cream color for AppBar icons.
    ),
  ),

  // Sets the theme for the FloatingActionButton.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFAED581), // Custom color for the floating action button.
  ),

  // Defines the style for TextButtons to align with the theme.
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF111D13), // Dark green color for text on buttons.
    ),
  ),
  
  useMaterial3: true, // Opt-in to using Material 3 design components.
);
