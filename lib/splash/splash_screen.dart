
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:untitled/models/user_model.dart';

import '../provider/auth_provider.dart';

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
    Timer(const Duration(seconds: 5), () {
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
    final app = Provider.of<AuthMobProvider>(context, listen: false);
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/wallet.png'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
           const SizedBox(height: 20.0),

           ElevatedButton(onPressed: (){
              app.isSignedIn == true ? Navigator.pushReplacementNamed(context, '/home') :
              Navigator.pushReplacementNamed(context, '/login');
           }, child: const Text('Skip'))
          ],
        ),
      ),

    );
  }
}
