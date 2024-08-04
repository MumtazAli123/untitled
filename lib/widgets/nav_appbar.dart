// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/modules/home/views/home_view.dart';
import 'mix_widgets.dart';

class NavAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? preferredSizeWidget;
  final String? title;
  const NavAppBar({super.key, this.preferredSizeWidget, this.title});

  @override
  State<NavAppBar> createState() => _NavAppBarState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _NavAppBarState extends State<NavAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.deepPurpleAccent,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeView()));
        },
        child: wText(
          "${widget.title}",
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(onPressed: (){
          Get.toNamed('/home');
        }, icon: Icon(Icons.home, color: Colors.white)),
        IconButton(onPressed: (){}, icon: Icon(Icons.search, color: Colors.white)),

        IconButton(
            onPressed: () {
              Get.toNamed('/notification');
            },
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
            icon: Icon(
              Icons.lock,
              color: Colors.white,
            )),
      ],
    );
  }
}
