import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


wText(String upperCase) {
  return Text(
    upperCase,
    style: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}