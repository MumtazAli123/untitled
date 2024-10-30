import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../../models/personModel.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  late Rx<File?> pickedFile;

  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  pickImage(ImageSource gallery) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      Get.snackbar('Success', 'Image Picked');
      pickedFile = Rx<File?>(File(imageFile!.path));
    } else {
      Get.snackbar('Error', 'No Image Selected');
    }
  }

  captureImage(ImageSource camera) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      Get.snackbar('Success', 'Image Captured');
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

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

  var upperCaseTextFormatter = FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'));



  @override
  void onInit() {
    super.onInit();
    countryCode = selectedCountry.phoneCode;
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

  void addDataAndSave(String value) {
    isUpload.value = true;
    if (user != null) {
      FirebaseFirestore.instance.collection('sellers').doc(user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'city': cityController.text,
        'uid': user!.uid,
        'image': value,
        'date': date,
      }).then((value) {
        isUpload.value = false;
        Get.offAllNamed('/home');
      }).catchError((e) {
        isUpload.value = false;
        Get.back();
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Error',
        );
      });
    }
  }

  void registerUser() {
    fAuth
        .createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((value) {
      addDataAndSave(value.user!.uid);
    }).catchError((e) {
      Get.snackbar('Error', e.toString());
    });
  }

  void createUserAccount(PersonModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: user.email!,
          password: passwordController.text
      );
      if (userCredential.user != null) {
        await uploadImageToStorage(profileImage);
      }

    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    QuickAlert.show(
      width: 400,
      context: Get.context!,
      type: QuickAlertType.loading,
      title: 'Please wait...',
    );
    bool isPhoneNoAvailable = await isUserPhoneAvailable(
        "+$countryCode${phoneController.text}");

    try {
      if (isPhoneNoAvailable) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          uid = value.user!.uid;
          uploadImageToStorage(profileImage!);
          // _saveUserData('');
        });
      } else {
        Get.back();
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Phone number already exists',
        );
      }
    } catch (e) {
      Get.back();
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Error',
        text: e.toString(),
      );
    }
  }


  uploadImageToStorage(File? imageProfile) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('sellers')
        .child('$uid.jpg');
    firebase_storage.UploadTask uploadTask = ref.putFile(imageProfile!);
    uploadTask.whenComplete(() async {
      try {
        String url = await ref.getDownloadURL();
        addDataAndSave(url);
      } catch (onError) {
        Get.back();
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Error',
          text: onError.toString(),
        );
      }
    });
  }

  isUserPhoneAvailable(String phone) {
    return FirebaseFirestore.instance
        .collection('sellers')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    });
  }




}
