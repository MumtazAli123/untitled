import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/user_model.dart';

class BudgetController extends GetxController {
  //TODO: Implement BudgetController

  final transferNominalController = TextEditingController();
  final descriptionController = TextEditingController();

  final totalBalance = 0.obs;

  var addMoney = 0.0.obs;
  var sendMoney = 0.0.obs;

  var type = ''.obs;


  var isRefresh = false.obs;

  var statementInOutList= [].obs;

  var isLoading = false.obs;

  final db = FirebaseFirestore.instance;
  UserModel userModel = UserModel();

  var incomeList = [].obs;




  @override
  void onInit() {
    super.onInit();
    statementInOut();

  }

  void increment() => totalBalance.value++;
  void decrement(double parse) {
    if (totalBalance.value > 0) {
      totalBalance.value--;
    }
  }


  @override
  void onClose() {}

  void statementInOut() async {
    var snapshot = await db.doc('statement').collection('in_out').get();
    statementInOutList.value = snapshot.docs.reversed.toList();
  }

  void streamStatementInOut() async {
    await for (var snapshot
        in db.doc('statement').collection('in_out').snapshots()) {
      statementInOutList.value = snapshot.docs.reversed.toList();
    }
  }

  void addStatementInOut() async {
    await db.doc('statement').collection('in_out').add({
      'type': type.value,
      'amount': addMoney.value,
      'created_at': DateTime.now(),
    });
    refresh();
  }

  void sendStatementInOut() async {
    // save other user data
    await db.doc('users').collection('statement').add({
      "user_id": userModel.uid,
      'name': userModel.fullName,
      'phone': userModel.number,
      'email': userModel.email,
      'type': "send",
      'amount': transferNominalController.text.trim(),
      'description': descriptionController.text.trim() == '' ? 'No description' : userModel.fullName,

      'created_at': DateTime.now(),
    });
    refresh();
  }

  void incomeStatementInOut() async {
    await db.doc('users').collection('statement').add({
      "user_id": userModel.uid,
      'name': userModel.fullName,
      'phone': userModel.number,
      'type': 'income',
      'amount': addMoney.value,
      'created_at': DateTime.now(),
    });
    refresh();
  }






  @override
  void refresh() {
    isRefresh.value = !isRefresh.value;
  }

  void clear() {
    addMoney.value = 0.0;
    sendMoney.value = 0.0;
  }

  void clearType() {
    type.value = '';
  }

  void clearAll() {
    clear();
    clearType();
  }




}
