// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:untitled/drawer/drawer.dart';
import 'package:untitled/widgets/nav_appbar.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController controller = Get.put(NotificationController());

  NotificationController get _controller => controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: NavAppBar(
        title: 'Notification',
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GFButton(
                  text: "Bottom",
                  onPressed: () {
                    _buildBottomSheet();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future _buildBottomSheet() {
    final size = MediaQuery.of(context).size;
    return Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      Container(
        height: size.height * 0.9,
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              title: Text('Item 3'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
