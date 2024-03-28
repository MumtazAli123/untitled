// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:untitled/app/modules/auth/views/registration_view.dart';
import 'package:untitled/drawer/drawer.dart';

import '../../../../widgets/mix_widgets.dart';

class MobAuthView extends StatefulWidget {
  const MobAuthView({super.key});

  @override
  State<MobAuthView> createState() => _MobAuthViewState();
}

class _MobAuthViewState extends State<MobAuthView> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObSecure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: Get.theme.iconTheme,
        title: Text('Budget App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Image.asset('images/logo.png', height: 150.0, width: 250.0),
              SizedBox(height: 20.0),
              Text('Welcome to Budget App',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              Text('Please sign in to continue',
                  style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(10.0),
                width: 450.0,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(10.0),
                width: 450.0,
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _toggle();
                      },
                      icon: Icon(
                          isObSecure ? Icons.visibility : Icons.visibility_off),
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(10.0),
                width: 250.0,
                height: 80.0,
                child: ElevatedButton(
                  onPressed: () {
                    createUserAndPassword(context, emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.brightness == Brightness.light
                        ? Colors.blue
                        : Colors.white,
                    foregroundColor: Get.theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: wText('Sign In'),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Get.to(() => RegistrationView());
                    },
                    child: wText('Sign Up', color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle() {
    if (mounted){
      setState(() {
        isObSecure = !isObSecure;
      });
    }
  }

  Future<void> createUserAndPassword(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) => Get.snackbar('Success', 'Registration Success'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Weak Password', 'The password provided is too weak.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Email Already in Use', 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
