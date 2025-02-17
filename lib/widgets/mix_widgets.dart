// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';


bool isLoading = false;

aText(String text, { Color? color, double? size}) {
  return Text(
    text,
    style: GoogleFonts.roboto(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
    ),
  );
}
wText(String upperCase,  { Color? color, double? size}) {
  return Text(
    upperCase,
    style: GoogleFonts.roboto(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}
eText(String s, {double size = 20, Color color = Colors.black}) {
  return Text(
    textAlign: TextAlign.center,
    s, style: GoogleFonts.salsa(fontSize: size, color: color),);
}

cText(String upperCase, {Color? color,  double? size}) {
  return Text(
    textAlign: TextAlign.center,
    upperCase,
    style: GoogleFonts.cabin(
      fontSize: size,
      // fontWeight: FontWeight.bold,
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

// customButton

wButton(String text, {Color? color, double size = 16, Function()? onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: isLoading
        ? const CircularProgressIndicator()
        : Container(
      alignment: Alignment.center,
      width: 250,
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: wText(
        text,
        color: Colors.white,
        size: 20,
      ),
    ),
  );
}
Future<XFile?> pickImage() async {
  XFile? image;
  try {
   final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
   if(pickedImage != null) {
     image = XFile(pickedImage.path);
   }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return image;
}


void wGetSnackBar(String title, String text) {
  Get.snackbar(title, text,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white);
}


