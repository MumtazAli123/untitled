// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'mix_widgets.dart';

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


  void verifyPhoneNumber()  {
    // final app = Provider((ref) => AuthMobProvider());
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
        centerTitle: true,
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
                    width: 350,
                    height: 140,
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
                      if (_formKey.currentState!.validate()) {
                        sendPhoneNumber();
                      }
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
  void sendPhoneNumber() async {
    final ap = Provider.of<AuthMobProvider>(context, listen: false);
   String phone = '+${selectedCountry.phoneCode}${phoneController.text.trim()}';
    print(phone);
    ap.verifyPhoneNumber(phoneNumber: phone);
  }
}
