import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final viewModel =
ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  bool isSignIn = false;
  bool isObSecure = false;

  Future<void> isLoggedIn() async {
    try {
      _auth.authStateChanges().listen((User? user) {
        if (user == null) {
          isSignIn = false;
        } else {
          isSignIn = true;
        }
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }

  }

  toggleSignIn() {
    isObSecure = !isObSecure;
    notifyListeners();
  }


}
