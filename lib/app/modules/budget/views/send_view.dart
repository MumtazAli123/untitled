// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/app/modules/home/views/home_view.dart';

import '../../../../models/user_model.dart';

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
          uid: uid,
          balance: userData['balance'] ?? 0,
        );
        otherUsers.add(otherUser);
      }

      setState(() {});
    }
  }

  void sendMoneyToUser(UserModel recipient) async {
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

        setState(() {
          loggedInUser.balance = updatedBalance;
        });

        Get.snackbar('Success', 'Money sent successfully');




        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomeView()),
        //     (route) => false);

        Get.offAll(HomeView());

      } else {

        Get.snackbar('Error', 'Insufficient balance to send money');
      }
    }
  }

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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Enter Amount'),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller:
                                                    transferNominalController,
                                                decoration: InputDecoration(
                                                    hintText: 'Input Nominal'),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                child: Text("Submit"),
                                                onPressed: () {
                                                  sendMoneyToUser(recipient);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
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
}
