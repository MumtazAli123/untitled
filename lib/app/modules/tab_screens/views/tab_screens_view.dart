// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../global/global.dart';
import '../../../../models/personModel.dart';
import '../controllers/tab_screens_controller.dart';

class TabScreensView extends StatefulWidget {
  const TabScreensView({super.key});

  @override
  State<TabScreensView> createState() => _TabScreensViewState();
}

class _TabScreensViewState extends State<TabScreensView> {
  final TabScreensController controller = Get.put(TabScreensController());

  retrieveUserInfo(){
    FirebaseFirestore.instance.collection('sellers')
        .where("uid", isNotEqualTo: fAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      List<PersonModel> profilesList = [];
      for (var eachProfile in snapshot.docs) {
        profilesList.add(PersonModel.fromDataSnapshot(eachProfile));
      }
      return profilesList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabScreensView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TabScreensView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
