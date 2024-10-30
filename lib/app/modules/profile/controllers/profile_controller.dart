import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:untitled/global/global.dart';
import 'package:untitled/models/personModel.dart';

class ProfileController extends GetxController {
  final Rx<List> usersProfilesList = Rx<List>([]);
  List get usersProfiles => usersProfilesList.value;

  @override
  void onInit() {
    super.onInit();
    usersProfilesList.bindStream(FirebaseFirestore.instance
        .collection('sellers')
        .where("uid", isNotEqualTo: fAuth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      List<PersonModel> profilesList = [];
      for (var eachProfile in snapshot.docs) {
        profilesList.add(PersonModel.fromDataSnapshot(eachProfile));
      }
      return profilesList;
    }));

  }


  @override
  void onClose() {}

  favoriteSendAndReceive(String toUserID, String userName) async {
    var document = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(toUserID)
        .collection('favorites')
        .doc(fAuth.currentUser!.uid)
        .get();
    // remove from database
    if (document.exists) {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(toUserID)
          .collection('favorites')
          .doc(fAuth.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(fAuth.currentUser!.uid)
          .collection('favoritesSent')
          .doc(toUserID)
          .delete();
    //   like count
    //   await FirebaseFirestore.instance
    //       .collection('sellers')
    //       .doc(toUserID)
    //       .update({'likes': FieldValue.increment(-1)});
    } else {
      // add to database
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(toUserID)
          .collection('favorites')
          .doc(fAuth.currentUser!.uid)
          .set({});

      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(fAuth.currentUser!.uid)
          .collection('favoritesSent')
          .doc(toUserID)
          .set({});

      // like count update
      // await FirebaseFirestore.instance
      //     .collection('sellers')
      //     .doc(toUserID)
      //     .update({'likes': FieldValue.increment(1)});


      // send notification
    }
    update();
  }
}
