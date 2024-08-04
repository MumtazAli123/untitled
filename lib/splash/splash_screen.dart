
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wallet.png'),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00B686),
                Color(0xFF00838F),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // lottie animation
              Container(
                height: 200,
                width: 200,
                decoration:  const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset('assets/lottie/enjoy.json'),

              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
             const SizedBox(height: 20.0),

             ElevatedButton(onPressed: (){
                app.isSignedIn == true ? Navigator.pushReplacementNamed(context, '/home') :
                Navigator.pushReplacementNamed(context, '/login');
             }, child: const Text('Skip'))
            ],
          ),
        ),
      ),

    );
  }
}
