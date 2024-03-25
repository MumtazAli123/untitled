import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  secondaryHeaderColor: Colors.grey[800],
  brightness: Brightness.dark,
  hintColor: Colors.white,
  dividerColor: Colors.black12,
  colorScheme: const ColorScheme.dark().copyWith(background: Colors.black),
);