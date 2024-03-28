// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/app/modules/counter/views/counter_view.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: Theme.of(context).brightness == Brightness.dark
                ? BoxDecoration(color: Colors.black )
                : BoxDecoration(color: Colors.white),
            currentAccountPictureSize: Size.square(50),
            accountName: Text('John Doe'),
            accountEmail: Text('j@gmail.com'),
            currentAccountPicture: CircleAvatar(

              backgroundImage: AssetImage('images/call.png'),
              backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
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
              Get.to(() => CounterView());
            },
          ),
        //   budget
          ListTile(
            title: Text('Budget'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.toNamed('/budget');
            },
          ),
          ListTile(
            title: Text('Auth'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.toNamed('/auth');
            },
          ),

        ],
      ),
    );
  }
}
