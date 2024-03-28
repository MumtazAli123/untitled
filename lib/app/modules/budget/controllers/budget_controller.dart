import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BudgetController extends GetxController {
  //TODO: Implement BudgetController

  final addBudget = FirebaseFirestore.instance;



  List incomeName = [];
  List incomeAmount = [];
  List expensesName = [];
  List expensesAmount = [];

  final totalIncome = 0.0.obs;
  final totalExpenses = 0.0.obs;

  double budgetLeft = 0.0;



  void calculate() {
    for (var i = 0; i < incomeAmount.length; i++) {
      // totalIncome.value += double.parse(incomeAmount[i]);
      totalIncome.value += incomeAmount[i];
    }
    for (var i = 0; i < expensesAmount.length; i++) {
      // totalExpenses.value += double.parse(expensesAmount[i]);
      totalExpenses.value += expensesAmount[i];
    }
  }

  // budgetLeft = totalIncome.value - totalExpenses.value;

  void increment() {
    totalIncome.value++;
  }

  void decrement() {
   totalExpenses.value--;
  }

  void updateb() {
    budgetLeft = totalIncome.value - totalExpenses.value;
  }

  void addIncome(String name, double amount) {
    incomeName.add(name);
    incomeAmount.add(amount);
    calculate();
    update();
  }

  void addExpenses(String name, double amount) {
    expensesName.add(name);
    expensesAmount.add(amount);
    calculate();
    update();
  }

  void deleteIncome(int index) {
    incomeName.removeAt(index);
    incomeAmount.removeAt(index);
    calculate();
    update();
  }

  void deleteExpenses(int index) {
    expensesName.removeAt(index);
    expensesAmount.removeAt(index);
    calculate();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    calculate();
  }


}
