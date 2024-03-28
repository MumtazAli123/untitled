// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

wDialogBox(BuildContext context, String title, String content, Function() onPressed) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: wText(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: onPressed,
            child: wText('Ok'),
          ),
        ],
      );
    },
  );
}


