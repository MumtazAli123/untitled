import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/global/global.dart';

import '../../../../models/user_model.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  // select male female

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final currentScreen = 0.obs;

  final isLogin = false.obs;

  final isRegister = false.obs;

  final isUpload = false.obs;

  final isDefault = false.obs;

  final FocusNode nameFocus = FocusNode();

  final user = FirebaseAuth.instance.currentUser;

  final date = DateTime.now();

  var countryCode = '';
  var flagUri = '';
  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: "0300 1234567",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: "",
  );

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    countryCode = selectedCountry.phoneCode;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void increment() => count.value++;

  void addDataAndSave() {
    isUpload.value = true;
    QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.loading,
        title: 'Please wait',
    );
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'city': cityController.text,
        'uid': user!.uid,
        'date': date,
      }).then((value) {
        isUpload.value = false;
        Get.offAllNamed('/home');
      }).catchError((e) {
        isUpload.value = false;
        Get.snackbar('Error', e.toString());
      });
    }
  }

  void registerUser() {
    fAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      addDataAndSave();
    }).catchError((e) {
      Get.snackbar('Error', e.toString());
    });
  }
}
