import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final totalBalance = 0.obs;

  var incomeList = [].obs;
  var expenseList = [].obs;
  var type = ''.obs;

  // get time ago

  var timeAgo = '';

  var isRefresh = false.obs;

  var isBalance = false.obs;

  void increment() => totalBalance.value++;
  void decrement() => totalBalance.value--;

  void article() async {
    var snapshot = await FirebaseFirestore.instance.collection('article').get();
    incomeList.value = snapshot.docs.reversed.toList();
  }

  void streamArticle() async {
    var logger = Logger();

    await for (var snapshot
        in FirebaseFirestore.instance.collection('article').snapshots()) {
      incomeList.value = snapshot.docs.reversed.toList();
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
  void onClose() {}

  void addArticle(String text, String text2, String text3) {
    FirebaseFirestore.instance.collection('article').add({
      'title': text,
      'body': text2,
      "balance": text3,
      'created_at': DateTime.now().toString(),
      'type': 'income',
    }).then((value) {
      article();
    });
  }

  void updateArticle(id, Map<String, String> map) {
    FirebaseFirestore.instance
        .collection('article')
        .doc(id)
        .update(map)
        .then((value) {
      article();
    });
  }

  void deleteArticle(id) {
    FirebaseFirestore.instance
        .collection('article')
        .doc(id)
        .delete()
        .then((value) {
      article();
    });
  }

  void addExpense(String title, String balance, String text3) {
    FirebaseFirestore.instance.collection('article').add({
      'title': title,
      'balance': balance,
      'body': text3,
      'created_at': DateTime.now().toString(),
      'type': 'expense',

    }).then((value) {
      article();
    });
  }

  void updateExpense(id, Map<String, String> map) {
    FirebaseFirestore.instance
        .collection('expense')
        .doc(id)
        .update(map)
        .then((value) {
      article();
    });
  }

  void deleteExpense(id) {
    FirebaseFirestore.instance
        .collection('expense')
        .doc(id)
        .delete()
        .then((value) {
      article();
    });
  }
}
