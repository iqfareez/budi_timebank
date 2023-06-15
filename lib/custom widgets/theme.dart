import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData1() {
  return ThemeData(
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Color.fromARGB(255, 0, 146, 143)),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),

      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 146, 143))),
      //Color.fromARGB(255, 245, 167, 44)
      labelStyle: TextStyle(
        //fontSize: 35,
        color: Color.fromARGB(255, 0, 146, 143),
      ),
    ),
    appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 0, 146, 143)),
    primaryColor: const Color.fromARGB(255, 0, 146, 143),
    //const Color.fromARGB(255, 127, 17, 224) purple
    //const Color.fromARGB(255, 89, 175, 89) green uia
    secondaryHeaderColor: const Color.fromARGB(255, 213, 159, 15),
    //const Color.fromARGB(255, 245, 167, 44) gold

    textTheme: GoogleFonts.interTextTheme(),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 7, 197, 236),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 7, 197, 236),
      ),
    ),
  );
}

ThemeData themeData2() {
  return ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),

      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 89, 175, 89))),
      //Color.fromARGB(255, 245, 167, 44)
      labelStyle: TextStyle(
        //fontSize: 35,
        color: Color.fromARGB(255, 89, 175, 89),
      ),
    ),
    appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 65, 13, 214)),
    //Color.fromARGB(255, 65, 13, 214)
    primaryColor: const Color.fromARGB(255, 89, 175, 89),
    //const Color.fromARGB(255, 0, 146, 143) uia blue
    secondaryHeaderColor: const Color.fromARGB(255, 7, 197, 236),
    dividerColor: const Color.fromARGB(255, 65, 13, 214),
    //canvasColor: const Color.fromARGB(255, 65, 13, 214),
    textTheme: GoogleFonts.interTextTheme(),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 7, 197, 236),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 7, 197, 236),
      ),
    ),
  );
}

ThemeData themeData3() {
  return ThemeData(primaryColor: const Color.fromARGB(255, 71, 85, 92));
}
