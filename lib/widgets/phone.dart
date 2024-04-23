// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled/widgets/mix_widgets.dart';

import 'otp_page.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String countryCode = '';
  String flagUri = '';

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

  FirebaseAuth auth = FirebaseAuth.instance;

  final otpController = TextEditingController();

  final code = '';

  bool isLoading = false;

  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: "0300 1234567",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: "",
  );

  fromValidation() {
    if (phoneController.text.isEmpty) {
      return 'Enter phone number';
    } else if (phoneController.text.length < 10) {
      return 'Enter valid phone number';
    } else if (countryCode.isEmpty) {
      return 'Select country code';
    } else {
      return verifyPhoneNumber();
    }
  }

  void verifyPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+$countryCode${phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Enter OTP'),
              content: Pinput(
                focusedPinTheme: submittedPinTheme,
                submittedPinTheme: focusedPinTheme,

                length: 6,
                // defaultPinTheme: defaultPinTheme,
                validator: (val) {
                  return val!.length == 6 ? null : 'Enter 6 digit OTP';
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OTPView(
                          verificationId: verificationId,
                        ),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register '),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 250,
                    height: 20,
                    child: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  wText("Let's get started"),
                  cText('We will send you an OTP to verify your phone number'),
                  const SizedBox(height: 20.0),
                  wText('Enter Phone Number'),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: phoneController,
                    maxLength: 10,
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: 'Phone Number',
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                  countryCode = country.phoneCode;
                                  flagUri = country.flagEmoji;
                                });
                              },
                            );
                          },
                          child: Text(
                            '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      suffixIcon: phoneController.text.length > 9
                          ? Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  wButton(
                    onPressed: () {
                      fromValidation();
                    },
                    text: 'Send OTP',
                    color: Colors.green,
                    textColor: Colors.white,
                    width: 200,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
