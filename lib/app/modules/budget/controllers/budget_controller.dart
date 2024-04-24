import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BudgetController extends GetxController {
  //TODO: Implement BudgetController

  final addBudget = FirebaseFirestore.instance;



  var totalBudget = 0.0.obs;
  var totalExpense = 0.0.obs;

  var isRefresh = false.obs;

  // refresh the page

  @override
  void refresh() {
    totalBudget.value = 0;
    totalExpense.value = 0;
    calculate();
  }



  void calculate() {
    totalBudget.value = 0;
    totalExpense.value = 0;
    addBudget.collection('budget').get().then((value) {
      for (var element in value.docs) {
        totalBudget.value += element['amount'];
      }
    });

    addBudget.collection('expense').get().then((value) {
      for (var element in value.docs) {
        totalExpense.value += element['amount'];
      }
    });
  }


  @override
  void onInit() {
    super.onInit();
    calculate();
  }


}
