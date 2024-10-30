import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AnimationControllerPage extends GetxController {
  //TODO: Implement AnimationController

  final count = 0.obs;

  var width = 100.0.obs;
  var height = 100.0.obs;

  var color = Colors.red.obs;



  @override
  void onClose() {}
  void increment() => count.value++;

  void changeValues( width, height, color) {
    width.value = width.value == 200 ? 100 : 200;
    height.value = height.value == 200 ? 100 : 200;
    color.value = color.value == Colors.red ? Colors.blue : Colors.red;
  }
}
