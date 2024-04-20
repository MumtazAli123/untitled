// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:untitled/app/modules/budget/views/send_view.dart';
import 'package:untitled/app/modules/budget/views/topup_view.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/currency_format.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Widget balanceCard() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(245, 152, 53, 0.498),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CurrencyFormat.convertToIdr(loggedInUser.balance ?? 0, 2),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 28),
            ),
            SizedBox(height: 4),
            Text(
              "Total Balance",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Row _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TopUpScreen()));
          },
          child: _buildCategoryCard(
            bgColor: Color(0xffcfe3ff),
            iconColor: Color(0xff3f63ff),
            iconData: Icons.add,
            text: "Top Up",
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SendView()));
          },
          child: _buildCategoryCard(
            bgColor: Color(0xfffbcfcf),
            iconColor: Color(0xfff54142),
            iconData: Icons.send,
            text: "Send",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Image.asset(
                        "assets/images/back.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    ActionChip(
                      label: Text("Logout"),
                      onPressed: () {
                        logout(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Welcome Back, ${loggedInUser.fullName}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                balanceCard(),
                SizedBox(height: 15),
                _buildCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.toNamed('/auth');
  }

  Column _buildCategoryCard(
      {Color? bgColor, Color? iconColor, IconData? iconData, String? text}) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 36,
          ),
        ),
        SizedBox(height: 8),
        Text(text!),
      ],
    );
  }
}