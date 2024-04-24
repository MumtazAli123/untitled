// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:untitled/widgets/phone.dart';

import '../app/modules/auth/views/mob_auth_view.dart';
import '../app/modules/auth/views/registration_view.dart';
import '../provider/auth_provider.dart';

class OTPView extends StatefulWidget {
  final String verificationId;

  const OTPView({super.key, required this.verificationId});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      color: Colors.green,
      fontSize: 24,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
    ),
  );
  final submittedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      color: Colors.red,
      fontSize: 24,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      color: Colors.green,
      fontSize: 24,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.green,
        width: 2,
      ),
    ),
  );

  String otpCode = '';


  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthMobProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? Center(
          child: Text("$isLoading User is Exist"),
        )
            :Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/images/login.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Pinput(
                      focusedPinTheme: submittedPinTheme,
                      submittedPinTheme: focusedPinTheme,
                      length: 6,
                      // onSubmitted: (value) {
                      //   setState(() {
                      //     otpCode = value;
                      //   });
                      // },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid OTP';
                        }
                        return null;
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (val) {
                        setState(() {
                          otpCode = val;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromRGBO(242, 174, 100, 1),
                      child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: double.infinity,
                        onPressed: () {
                          if (otpCode != null && otpCode.length == 6) {
                            verifyOTP(context, otpCode);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid OTP'),
                              ),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => RegistrationView(),
                          //   ),
                          // );

                        },
                        child: Text(
                          'Verify',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive the code?"),
                        TextButton(
                          onPressed: () {
                            _resendOTP();
                          },
                          child: Text("Resend"),
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
    );
  }

  void verifyOTP(BuildContext context, String userOtp) {
    final app = Provider.of<AuthMobProvider>(context, listen: false);
    app.verifyOTP(
    context: context,
    otp: userOtp,
    verificationId: widget.verificationId,
    onSuccess: () {
      app.checkUserExist(app.uid).then((value) {
        if (value == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobAuthView(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationView(),
            ),
          );
        }
      });
    });

  }

  void _resendOTP (){

  }
}
