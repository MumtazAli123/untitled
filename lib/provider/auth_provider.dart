
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/models/user_model.dart';

import '../widgets/otp_page.dart';

class AuthMobProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String _uid;
  String get uid => _uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isLogin') ?? false;
    notifyListeners();
  }

  void verifyPhoneNumber(String phoneNumber) async {
    try {
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

//   verify Otp
  void verifyOTP(
      {required BuildContext context,
      required String otp,
      required String verificationId,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      User user = (await _auth.signInWithCredential(credential)).user!;
      if (user != null) {
        // _isSignedIn = true;
        // notifyListeners();
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool('isLogin', true);
        _uid = user.uid;
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.message ?? 'An error occurred', 'Please try again');
    }
  }

  // database operation
  Future<bool> checkUserExist(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      print('User Exist');
      return true;
    } else {
      print('New User');
      return false;
    }
  }

  void saveUserDataToFirebase({
  required BuildContext context,
  required UserModel user,
  required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      _isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      Get.snackbar(e.toString(), 'An error occurred');
    }
  }

  void signOut() async {
    await _auth.signOut();
    _isSignedIn = false;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
  }
}
