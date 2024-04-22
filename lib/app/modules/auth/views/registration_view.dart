// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/otp_page.dart';
import 'mob_auth_view.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  final number = TextEditingController();
  final balance = 0;
  bool _obscureText = true;

  final date = DateTime.now();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
      autofocus: false,
      controller: fullName,
      validator: (value) {
        RegExp regex = RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Full Name can't be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Full Name should at least be 5 characters");
        }
        return null;
      },
      onSaved: (value) {
        fullName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_box),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Full Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final usernameField = TextFormField(
      autofocus: false,
      controller: username,
      validator: (value) {
        RegExp regex = RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Please Enter Your Full Name");
        }

        if (!regex.hasMatch(value)) {
          return ("Username should at least be 5 characters");
        }

        return null;
      },
      onSaved: (value) {
        username.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        email.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final numberField = TextFormField(
      autofocus: false,
      controller: number,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Phone Number");
        }
        if (value.length < 10) {
          return ("Please Enter a valid Phone Number");
        }
        return null;
      },
      onSaved: (value) {
        number.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordField = Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            autofocus: false,
            controller: password,
            obscureText: _obscureText,
            validator: (value) {
              RegExp regex = RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required for login");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Password(Min. 6 Character)");
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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

    final confirmPasswordField = Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            autofocus: false,
            controller: confirm,
            obscureText: _obscureText,
            validator: (value) {
              if (password.value != confirm.value) {
                return ("Password don't match");
              }

              return null;
            },
            onSaved: (value) {
              confirm.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.vpn_key),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(242, 174, 100, 1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: double.infinity,
        onPressed: () {
          signUp(email.text, password.text);

        },
        child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                          child: Image.asset(
                            "assets/images/wallet.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 30),
                        fullNameField,
                        SizedBox(height: 15),
                        usernameField,
                        SizedBox(height: 15),
                        emailField,
                        SizedBox(height: 15),
                        numberField,
                        SizedBox(height: 15),
                        passwordField,
                        SizedBox(height: 15),
                        confirmPasswordField,
                        SizedBox(height: 30),
                        registerButton,
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MobAuthView(),
                                  ),
                                );
                              },
                              child: Text("Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      // Check if the username is unique before registering
      bool isUsernameUnique = await isUsernameAvailable(username.text);

      if (isUsernameUnique) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => postDetailsToFireStore())
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } else {
        Fluttertoast.showToast(msg: "Username is already taken");
      }
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final query = await firebaseFirestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    return query.docs.isEmpty;
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore =
        FirebaseFirestore.instance; // to call firestore
    User? user = _auth.currentUser; // to call user model

    UserModel userModel = UserModel(); // sending the values

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullName.text;
    userModel.username = username.text;
    userModel.number = number.text;
    userModel.balance = 0;
    // userModel.createdAt = date;
    // userModel.updatedAt = date;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPView(),
      ),
    );

  }

}





