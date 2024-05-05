// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/app/modules/budget/views/send_view.dart';
import 'package:untitled/app/modules/budget/views/topup_view.dart';
import 'package:untitled/app/modules/home/controllers/home_controller.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/currency_format.dart';

class BudgetView extends StatefulWidget {
  UserModel loggedInUser = UserModel();
  BudgetView({super.key, required this.loggedInUser});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  // final HomeController controller = Get.put(HomeController());
  final controller = Get.put(HomeController());
  bool isIncome = true;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    controller.streamArticle();
  }

  Widget balanceCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 200,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff3f63ff),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Balance",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              "PKR: ${currencyFormat(loggedInUser.balance)}",
              //

              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 28),
            ),
            SizedBox(height: 4),
            Divider(color: Colors.white),
            //   in word like three thousand four hundred and fifty first word is capital
            Text(
              "Bal, ${NumberToWord().convert(loggedInUser.balance!.toInt())}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "Last Updated: ${DateTime.now().toString().substring(0, 16)}",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
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
                context,
                MaterialPageRoute(
                    builder: (context) => SendView(
                          recipient: loggedInUser,
                        )));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.backspace_sharp),
          onPressed: () {
            Get.toNamed('/home');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  "assets/images/wallet.png",
                  fit: BoxFit.contain,
                ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          //   refreshButton(),
          IconButton(
            onPressed: () {
              controller.streamArticle();
            },
            icon: controller.isRefresh.value
                ? Icon(Icons.refresh, color: Colors.green)
                : Icon(Icons.refresh_outlined, color: Colors.red),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("users").doc(user!.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                "Welcome, ${loggedInUser.fullName}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              balanceCard(),
              SizedBox(height: 20),
              _buildCategories(),
              SizedBox(height: 20),
              _buildStatementList(),
            ],
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  Column _buildCategoryCard(
      {Color? bgColor, Color? iconColor, IconData? iconData, text}) {
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

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  _buildStatementList() {
    return Expanded(
      flex: 1,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('statement')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No transaction yet"),
            );
          }
          return isIncome
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        _buildDialog(snapshot.data!.docs[index]);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          snapshot.data!.docs[index]['type'].toString() == "send"
                              ? "-"
                              : "+",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(snapshot.data!.docs[index]['name'].toString()),
                      subtitle: Text(snapshot.data!.docs[index]['type']
                          .toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
// isIncome type send or receive - PKR 100 or + PKR 100

                            snapshot.data!.docs[index]['type'] == "send"
                                ? "- PKR ${snapshot.data!.docs[index]['amount']}"
                                : "+ PKR ${snapshot.data!.docs[index]['amount']}",
                            style: TextStyle(
                                color: snapshot.data!.docs[index]['type'] == "send"
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ],
                      ),
                      // subtitle: Text(data['body']),
                      // trailing: Text(data['balance']),
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }

  void _buildDialog(QueryDocumentSnapshot<Object?> doc) {
    QuickAlert.show(
      context: context,
      title: doc['name'],
      text: doc['type'] == "send"
          ? "You sent PKR ${doc['amount']}"
          : "You received PKR ${doc['amount']}",
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Divider(),
          Text("Amount: PKR: ${doc['amount']}"),
          Text("Description: ${doc['description']}"),
          Text(
          GetTimeAgo.parse(DateTime.parse(doc['created_at'].toDate()
              .toString()),
              locale: 'en'),
        ),
        ],
      ), type: QuickAlertType.success,
      onConfirmBtnTap: (){
        Get.back();
      //   share slip
      }
    );
  }
  
}

