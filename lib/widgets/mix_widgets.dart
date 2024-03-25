import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


wText(String upperCase, { Color? color}) {
  return Text(
    upperCase,
    style: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

urlLauncher(String url, String image) {
  return IconButton(onPressed: () async{
    await launchUrl(Uri.parse(url));
  }, icon: Image.asset(image, width: 50.0, height: 50.0,));
}


wTextFormFiled(String hint, IconData?  icon, TextEditingController controller,TextInputType? keyboardType, {bool obscureText = false} ) {

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        onPressed: () {
          controller.clear();
        },
        icon: const Icon(Icons.clear),
      ),
      hintText: hint,
      labelText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}


