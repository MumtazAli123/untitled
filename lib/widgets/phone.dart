// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/modules/home/views/home_view.dart';

import '../provider/auth_provider.dart';
import 'mix_widgets.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String otpPin = " ";
  String countryCode = "+1";
  String countryDial = "+1";
  String verID = " ";

  int screenState = 0;

  Color blue = const Color(0xff8cccff);
  final _formKey = GlobalKey<FormState>();
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

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!", "You are now logged in");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!", e.message ?? "An error occurred");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!", "Please check your messages");
        verID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!", "Please try again");
      },
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    )
        .whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: wText('Register '),
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
                    cText(
                        'We will send you an OTP to verify your phone number'),
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
                       'Send OTP',
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // body: _buildBody(),
      ),
    );
  }

  void sendPhoneNumber() async {
    final ap = Provider.of<AuthMobProvider>(context, listen: false);
    String phone =
        '+${selectedCountry.phoneCode}${phoneController.text.trim()}';
    print(phone);
    ap.verifyPhoneNumber(phoneNumber: phone);
  }

  void showSnackBarText(String title, String text) {
    Get.snackbar(title, text,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
  }

  _buildBody() {
    return  SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight / 8),
              child: Column(
                children: [
                  Text(
                    "JOIN US",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 8,
                    ),
                  ),
                  Text(
                    "Create an account today!",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: screenWidth / 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: circle(5),
          ),
          Transform.translate(
            offset: const Offset(30, -30),
            child: Align(
              alignment: Alignment.centerRight,
              child: circle(4.5),
            ),
          ),
          Center(
            child: circle(3),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              height: bottom > 0 ? screenHeight : screenHeight / 2,
              width: screenWidth,
              color: Colors.white,
              duration: const Duration(milliseconds: 800),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: bottom > 0 ? screenHeight / 12 : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    screenState == 0 ? stateRegister() : stateOTP(),
                    GestureDetector(
                      onTap: () {
                        if(screenState == 0) {
                          if(usernameController.text.isEmpty) {
                            showSnackBarText("Username is still empty!",  "Please enter your username");
                          } else if(phoneController.text.isEmpty) {
                            showSnackBarText("Phone number is still empty!", "Please enter your phone number");
                          } else {
                            verifyPhone(countryDial + phoneController.text);
                          }
                        } else {
                          if(otpPin.length >= 6) {
                            verifyOTP();
                          } else {
                            showSnackBarText("Enter OTP correctly!", "Please enter the OTP sent to your phone");
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: screenWidth,
                        margin: EdgeInsets.only(bottom: screenHeight / 12),
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "CONTINUE",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

    );
  }

  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: countryDial + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and we can continue!",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        Pinput(
          length: 6,
          focusNode: FocusNode(),
          controller: otpController,
          onSubmitted: (String pin) {
            setState(() {
              otpPin = pin;
            });
          },
          submittedPinTheme: submittedPinTheme,
        ),
        const SizedBox(height: 20,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8,),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 16,),
        Text(
          "Phone number",
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8,),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                countryDial,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
