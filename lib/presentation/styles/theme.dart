import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      hintColor: Colors.yellowAccent,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white));
}

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      hintColor: Colors.deepOrangeAccent,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black));
}
