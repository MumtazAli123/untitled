import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabScreensController extends GetxController {
  //TODO: Implement TabScreensController

  final count = 0.obs;

  var tabController;
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
