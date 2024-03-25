import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  var articleList = [].obs;

  // get time ago

  var timeAgo = '';

  var isRefresh = false.obs;

  var isBalance = false.obs;


  void increment() => count.value++;
  void decrement() => count.value--;

  void article() async{
    var snapshot = await FirebaseFirestore.instance.collection('article').get();
    articleList.value = snapshot.docs.reversed.toList();
  }

  void streamArticle()async {
    var logger = Logger();

  await for (var snapshot in FirebaseFirestore.instance.collection('article').snapshots()) {
    articleList.value = snapshot.docs.reversed.toList();
    logger.i(timeAgo = snapshot.docs[0].data()['created_at']);

  }
  }

  @override
  void onInit() {
    super.onInit();
    // article();
    streamArticle();

  }


  @override
  void onClose() {

  }


  void addArticle(String text, String text2, String text3) {
    FirebaseFirestore.instance.collection('article').add({
      'title': text,
      'body': text2,
      "balance": text3,
      'created_at': DateTime.now().toString(),
    }).then((value) {
      article();
    });
  }

  void updateArticle(id, Map<String, String> map) {
    FirebaseFirestore.instance.collection('article').doc(id).update(map).then((value) {
      article();
    });
  }

  void deleteArticle(id) {
    FirebaseFirestore.instance.collection('article').doc(id).delete(
    ).then((value) {
      article();
    }
    );
  }

}
