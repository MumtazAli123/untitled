
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:untitled/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  final UserModel user = UserModel();
  FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentUser;

  startTimer() {
    fAuth.currentUser != null
        ? currentUser = fAuth.currentUser
        : currentUser = null;
    Timer(const Duration(seconds: 3), () {
      if (currentUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });


  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/wallet.png'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),

    );
  }
}
