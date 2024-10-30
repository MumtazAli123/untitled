// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:untitled/app/modules/products/views/products_view.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/simple_pdf_api.dart';
import '../../tab_screens/views/user_details_view.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController controller = Get.put(ProfileController());
  String? senderName;

  readCurrentUserData() async {
    // ignore: await_only_futures
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(fAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          senderName = snapshot.data()!['name'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: NavAppBar(title: 'Profile'),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Obx(() {
      if (controller.usersProfiles.isEmpty) {
        return Center(child: Text('No data'));
      } else {
        return PageView.builder(
          itemCount: controller.usersProfiles.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = controller.usersProfiles[index];
            return GestureDetector(
              onTap: () {
                _buildBottomSheet(context, data);
              },
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(data.image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // filter icon
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.filter_list,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                        Spacer(),
                        // name
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              wText(data.name.toString(),
                                  color: Colors.white, size: 30),
                              ElevatedButton(onPressed: () async {
                               // final simplePdfFile = await PdfApi.loadNetworkPdf(
                               //    data.image.toString()
                               //  );
                               //  SaveAndOpenDocument.openPdf(simplePdfFile);
                                Get.to(() => ProductsView());


                              }, child: Text('View Profile')),
                            ],
                          ),
                        ),
                        //   icon button
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // profile image
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => UserDetailsView(
                                        userID: data.uid.toString(),
                                      ));
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(data.image.toString()),
                                ),
                              ),
                              // star icon
                              IconButton(
                                onPressed: () async{
                                  // final simplePdfFile = await SimplePdfApi.generateSimpleTextPdf(
                                  //   "Seller: ${data.name.toString()}",
                                  //   "Buyer: $senderName",
                                  // );
                                  // SaveAndOpenDocument.openPdf(simplePdfFile);

                                  PdfApi.loadNetworkPdf(
                                    data.image.toString()
                                  );

                                },
                                icon: Icon(Icons.star,
                                    color: Colors.yellowAccent, size: 30),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.call,
                                    color: Colors.white, size: 30),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.message,
                                    color: Colors.white, size: 30),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.email,
                                    color: Colors.white, size: 30),
                              ),
                              //   favorite icon
                              LikeButton(
                                countPostion: CountPostion.right,
                                onTap: (isFavorite) async {
                                  controller.favoriteSendAndReceive(
                                      data.uid.toString(), senderName!);
                                  return !isFavorite;
                                },
                                likeBuilder: (isFavorite) {
                                  return Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                    size: 30,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          },
        );
      }
    });
  }

  void _buildBottomSheet(BuildContext context, data) {
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      Container(
        height: 900,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(data.name.toString()),
              subtitle: Text(data.email.toString()),
            ),
            ListTile(
              title: Text(data.phone.toString()),
              subtitle: Text(data.address.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
