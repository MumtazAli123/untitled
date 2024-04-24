// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_model.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../widgets/otp_page.dart';

class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<UserModel> otherUsers = [];

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

  final fb = FirebaseFirestore.instance;

  final TextEditingController transferNominalController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    if (user != null) {
      fetchLoggedInUserBalance(user!.uid);
    }
  }

  Future<void> fetchLoggedInUserBalance(String uid) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);

    DocumentSnapshot docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? userData =
          docSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        double userBalance = userData['balance'] ?? 0;

        setState(() {
          loggedInUser.balance = userBalance;
        });
      }
    }
  }

  Future<void> fetchUserData() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await usersCollection.get();

    otherUsers.clear();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;

      String uid = documentSnapshot.id;

      if (uid != user?.uid) {
        UserModel otherUser = UserModel(
          username: userData['username'],
          fullName: userData['fullName'],
          uid: uid,
          balance: userData['balance'] ?? 0,
        );
        otherUsers.add(otherUser);
      }

      setState(() {});
    }
  }

  // void sendMoneyToUser(UserModel recipient) async {
  //   if (user != null) {
  //     String enteredValue = transferNominalController.text;
  //
  //     int transferAmount = int.tryParse(enteredValue) ?? 0;
  //
  //     if (loggedInUser.balance != null &&
  //         loggedInUser.balance! >= transferAmount) {
  //       double updatedBalance = loggedInUser.balance! - transferAmount;
  //
  //       double recipientUpdatedBalance = (recipient.balance!) + transferAmount;
  //
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user!.uid)
  //           .update({'balance': updatedBalance});
  //
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(recipient.uid)
  //           .update({'balance': recipientUpdatedBalance});
  //
  //       setState(() {
  //         loggedInUser.balance = updatedBalance;
  //       });
  //
  //       Get.snackbar('Success', 'Money sent successfully',
  //           backgroundColor: Colors.green,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM);
  //
  //       _buildDialogWithDataReceiver(
  //           recipient.username, transferAmount, recipient.fullName!);
  //
  //     } else {
  //       Get.snackbar('Error', 'Insufficient balance to send money',
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
      ),
      body: ListView(
        children: otherUsers.map((recipient) {
          return Container(
            margin: EdgeInsets.all(20),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(245, 152, 53, 0.498),
            ),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${recipient.username}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _buildDialogSendMoney(recipient);
                        },
                        child: Text('Send Money'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void sendMoneyToUser(UserModel recipient) {
    if (user != null) {
      String enteredValue = transferNominalController.text;

      int transferAmount = int.tryParse(enteredValue) ?? 0;

      if (loggedInUser.balance != null &&
          loggedInUser.balance! >= transferAmount) {
        double updatedBalance = loggedInUser.balance! - transferAmount;

        double recipientUpdatedBalance = (recipient.balance!) + transferAmount;

        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'balance': updatedBalance});

        FirebaseFirestore.instance
            .collection('users')
            .doc(recipient.uid)
            .update({'balance': recipientUpdatedBalance});

        setState(() {
          loggedInUser.balance = updatedBalance;
        });

        _buildDialogWithDataReceiver(
            recipient.username, transferAmount, recipient.fullName!);
      } else {
        QuickAlert.show(
          barrierDismissible: false,
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Insufficient balance to send money',
        );
      }
    }
  }

  void _buildDialogSendMoney(UserModel recipient) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      // alert
      type: QuickAlertType.warning,
      barrierDismissible: true,
      confirmBtnText: 'Send Money',

      // customAsset: 'assets/images/wallet.png',
      title: 'Send Money',
      text: " Enter the amount you want to send to ${recipient.fullName}",
      textAlignment: TextAlign.center,
      widget: Column(
        children: [
          Text(
            textAlign: TextAlign.start,
            'Your balance: ${(loggedInUser.balance!)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textBaseline: TextBaseline.alphabetic,
            ),
            controller: transferNominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.black),
              hintText: 'Enter amount',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          //  enter type money show in currency format
        ],
      ),
      onConfirmBtnTap: () async {
        _validateField(recipient);
      },
    );
  }

  _validateField(UserModel? recipient) {
    if (transferNominalController.text.isEmpty) {
      QuickAlert.show(
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please enter amount',
      );
    } else {
      _otpSendFromFirebase(recipient!);
      // _otpSendMoney(recipient!);
      // sendMoneyToUser(recipient!);
    }
  }

  _otpSendFromFirebase(UserModel phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(

      phoneNumber: phone.username!,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        // Get.back();
        // _otpSendMoney( otherUsers[0]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPView(
              verificationId: verificationId,
              recipient: phone,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _otpSendMoney(UserModel recipient) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      type: QuickAlertType.warning,
      barrierDismissible: false,
      confirmBtnText: 'Send Money',
      title: 'Send Money',
      text: 'Enter OTP to send money',
      textAlignment: TextAlign.center,
      widget: Column(
        children: [
          SizedBox(height: 20.0),
          Pinput(
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            length: 6,
            onSubmitted: (value) {
              setState(() {
                otpCode = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a valid OTP';
              }
              return null;
            },
          ),
          SizedBox(height: 10.0),
        ],
      ),
      onConfirmBtnTap: () {
        Get.back();
        sendMoneyToUser(recipient);
      },
    );
  }

  void _buildDialogWithDataReceiver(
      String? username, int transferAmount, String fullName) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text:
          'Money sent to $fullName\nAmount: $transferAmount\nReceiver: $username',
      textAlignment: TextAlign.start,
      onConfirmBtnTap: () {
        Get.toNamed('/budget');
      },
    );
  }

  void _resendOTP(UserModel userModel) {
    final app = Provider.of<AuthMobProvider>(context, listen: false);
    app.resendOTP(
      context: context,
      userModel: userModel,
    );
  }
}
