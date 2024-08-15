// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:untitled/app/modules/home/controllers/home_controller.dart';
import 'package:untitled/widgets/nav_appbar.dart';


class HomeMapView extends GetView<HomeController> {
  const HomeMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavAppBar(
        title: 'HomeMapView',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // user profile data here
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return GFCard(
                      image: Image.network(
                        snapshot.data!.get('image').toString(),
                        fit: BoxFit.cover,
                      ),
                      showImage: true,
                      title: GFListTile(
                        avatar: GFAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data!.get('image').toString(),
                          ),
                        ),
                        title: Text(snapshot.data!.get('name')),
                        subTitle: Text(snapshot.data!.get('phone')),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${snapshot.data!.get('email')}"),
                          Text("Address: ${snapshot.data!.get('address')}"),
                          Text("City: ${snapshot.data!.get('city')}"),
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            // user products here

          ],
        ),
      ),
    );
  }


}


