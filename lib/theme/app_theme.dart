import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ✅ Define Primary Colors
  static const Color primaryColor = Color(0xFF007AFF); // Sleek blue tone
  static const Color secondaryColor = Color(0xFF2D2D2D); // Elegant dark gray
  static const Color accentColor = Color(0xFFFFC107); // ✅ Warm contrast color

  // ✅ Light Theme Configuration
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.transparent, // ✅ Set to transparent for background wrapper
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: GoogleFonts.poppins().fontFamily,

    // ✅ AppBar Theme with a Modern Look
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true, // Aligns title for a polished UI
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // ✅ Ensure title stays white
      ),
    ),

    // ✅ Text Theme for Better Readability
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: const TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: const TextStyle(fontSize: 16, color: Colors.black),
      bodySmall: const TextStyle(
          fontSize: 12, color: Colors.grey), // ✅ Makes small texts readable
    ),
    // ✅ Button Theme for Unified Styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// ✅ Background Wrapper for All Screens
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/logojj.png'), // ✅ Set background image
          fit: BoxFit.contain, // Keeps logo medium-sized
          alignment: Alignment.center, // ✅ Positions it in the center
          opacity: 0.15, // ✅ Adds fade effect
          
        ),
      ),
      child: child, // ✅ Places screen content inside this wrapper
    );
  }
}