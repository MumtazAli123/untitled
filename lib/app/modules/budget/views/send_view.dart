// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../models/user_model.dart';
import '../controllers/budget_controller.dart';

class SendView extends StatefulWidget {
  final UserModel? recipient;
  const SendView({super.key, this.recipient});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final controller = Get.put(BudgetController());

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
  final descriptionController = TextEditingController();

  UserModel userModel = UserModel();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  void sendMoneyToUser(UserModel recipient) async {
    //   send and save statement in_out of users
    if (user != null) {
      String enteredValue = transferNominalController.text;

      int transferAmount = int.tryParse(enteredValue) ?? 0;

      if (loggedInUser.balance != null &&
          loggedInUser.balance! >= transferAmount) {
        double updatedBalance = loggedInUser.balance! - transferAmount;

        double recipientUpdatedBalance = (recipient.balance!) + transferAmount;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'balance': updatedBalance});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(recipient.uid)
            .update({'balance': recipientUpdatedBalance});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('statement')
            .add({
          "user_id": recipient.uid,
          'name': recipient.fullName,
          'phone': recipient.number ?? 'No phone',
          'email': recipient.email ?? 'No email',
          'type': "send",
          'amount': transferNominalController.text.trim(),
          'description': descriptionController.text.trim() == ''
              ? 'No description'
              : recipient.fullName,
          'created_at': DateTime.now(),
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(recipient.uid)
            .collection('statement')
            .add({
          "user_id": user!.uid,
          'name': loggedInUser.fullName,
          'phone': loggedInUser.number ?? 'No phone',
          'email': loggedInUser.email ?? 'No email',
          'type': "receive",
          'amount': transferNominalController.text.trim(),
          'description': descriptionController.text.trim() == ''
              ? 'No description'
              : loggedInUser.fullName,
          'created_at': DateTime.now(),
        });

        setState(() {
          loggedInUser.balance = updatedBalance;
        });

        Get.snackbar('Success', 'Money sent successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);

        _buildDialogWithDataReceiver(
            recipient.username, transferAmount, recipient.fullName!);
      } else {
        Get.snackbar('Error', 'Insufficient balance to send money',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _buildDialogSendMoney(UserModel recipient) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      type: QuickAlertType.info,
      title: 'Send Money',
      text: 'Enter amount to send',
      textAlignment: TextAlign.center,
      widget: Column(
        children: [
          SizedBox(height: 20.0),
          TextFormField(
            controller: transferNominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter description',
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
      onConfirmBtnTap: () {
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
    } else if (recipient == null) {
      QuickAlert.show(
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please select a recipient',
      );
    } else {
      // _otpSendFromFirebase();
      // _otpSendMoney(recipient!);
      sendMoneyToUser(recipient);
    }
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

}
