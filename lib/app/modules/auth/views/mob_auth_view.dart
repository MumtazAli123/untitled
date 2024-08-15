// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/app/modules/home/views/home_view.dart';
import 'package:untitled/models/user_model.dart';
import 'package:untitled/widgets/phone.dart';

import '../../../../widgets/mix_widgets.dart';


class MobAuthView extends StatefulWidget {

 final UserModel?  user = UserModel();

   MobAuthView({super.key,});

  @override
  State<MobAuthView> createState() => _MobAuthViewState();
}

class _MobAuthViewState extends State<MobAuthView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscureText = true;
  bool showProgressBar = false;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailField = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 550,
      padding: EdgeInsets.only(right: 10),
      child: TextFormField(
        autofocus: false,
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          return null;
        },
        onSaved: (value) {
          email.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          // textInputAction: TextInputAction.next,
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          helperMaxLines: 1,
          border: InputBorder.none
        ),
      ),
    );

    final passwordField = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 550,
          padding: EdgeInsets.only(right: 10),
          child: TextFormField(
            autofocus: false,
            controller: password,
            obscureText: _obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Password is required for login");
              }
              return null;
            },
            onSaved: (value) {
              password.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.vpn_key),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: 'Password',
              border: InputBorder.none
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          ),
        )
      ],
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(0, 184, 134, 1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: double.infinity,
        onPressed: () {
          signIn(email.text, password.text);
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final registerLink = Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          wText('Don\'t have an account?', size: 16, color: Colors.white),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 5),
              child: wText(
                'Sign Up',
                color: Colors.yellow,

                size: 20,
              ),
            ),
            onTap: () => Get.toNamed('/register'),
          )
        ],
      ),
    );

    return Scaffold(
      // backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // yellow combine with pink
                  Color(0xFF00B686),
                  Color(0xFF00838F),


                  // Color(0xFF00B686),
                  // Color(0xFF00838F),
                ],
              ),
            ),
            // color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Lottie.asset('assets/lottie/animation.json'),
                            ),
                            SizedBox(height: 45),
                            emailField,
                            SizedBox(height: 30),
                            passwordField,
                            SizedBox(height: 30),
                            loginButton,
                            SizedBox(height: 30),
                            registerLink,
                            SizedBox(height: 15),
                            showProgressBar == true
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                            )
                                : Container(),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (user.user != null) {
          Get.to(() => HomeView());
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? 'An error occurred',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

}