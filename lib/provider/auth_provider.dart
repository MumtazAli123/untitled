import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/otp_page.dart';

class AuthMobProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isLogin') ?? false;
    notifyListeners();
  }

  void verifyPhoneNumber(String phoneNumber) async {
    try{
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _isSignedIn = true;
          notifyListeners();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLogin', true);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar(e.message ?? 'An error occurred', 'Please try again');
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.to(() => OTPView(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.message ?? 'An error occurred', 'Please try again');
    }
  }
}
