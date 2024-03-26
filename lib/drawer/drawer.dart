// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            currentAccountPictureSize: Size.square(50),
            accountName: Text('John Doe'),
            accountEmail: Text('j@gmail.com'),
            currentAccountPicture: CircleAvatar(

              backgroundImage: AssetImage('images/call.png'),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Counter'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.toNamed('/counter');
            },
          ),

        ],
      ),
    );
  }
}
