import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MobView extends GetView {
  const MobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
