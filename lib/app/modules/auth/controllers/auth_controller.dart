import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController

  // qrCode
  final qrCodeController = TextEditingController();

  var qrCode = ''.obs;
  // scan qr code
  String scanQrCode = '';

  var isLoading = false.obs;

  var isLogin = false.obs;

  var isRefresh = false.obs;

  var isBalance = false.obs;

  var isObscureText = true.obs;

  bool  mounted = false;

  void register(String name, String email, String phone, String address,
      String password) {
    isLoading(true);
    FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
    }).then((value) {
      isLoading(false);
      Get.snackbar('Success', 'Registration Success');
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    });
  }

  void login(String email, String password) {
    isLoading(true);
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isLoading(false);
        isLogin(true);
        Get.snackbar('Success', 'Login Success');
      } else {
        isLoading(false);
        Get.snackbar('Error', 'Email or Password is wrong');
      }
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    });
  }

  void logout() {
    isLogin(false);
  }

  void updateProfile(String name, String email, String phone, String address,
      String password) {
    isLoading(true);
    FirebaseFirestore.instance.collection('users').doc().update({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
    }).then((value) {
      isLoading(false);
      Get.snackbar('Success', 'Update Profile Success');
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    });
  }

  void deleteProfile(String id) {
    isLoading(true);
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete()
        .then((value) {
      isLoading(false);
      Get.snackbar('Success', 'Delete Profile Success');
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    });
  }

  void streamArticle() {
    FirebaseFirestore.instance
        .collection('article')
        .snapshots()
        .listen((event) {
      print(event.docs[0].data());
    });
  }

  void togglePassword() {
    isLoading(!isLoading.value);
  }



  @override
  void onClose() {}

  Future getBalance() async {
    isBalance(true);
    await Future.delayed(const Duration(seconds: 2));
    isBalance(false);
  }

  @override
  void refresh() {
    isRefresh(true);
    Future.delayed(const Duration(seconds: 2), () {
      isRefresh(false);
    });
  }

   Future<void> scanQr() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      Get.snackbar('QR Code', qrCode, snackPosition: SnackPosition.BOTTOM);
      if (!mounted) return;
      scanQrCode = qrCode;
      qrCodeController.text = scanQrCode;
    } on PlatformException {
      scanQrCode = 'Failed to get platform version.';
    }

  }
}


