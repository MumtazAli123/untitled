import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:untitled/app/modules/auth/views/registration_view.dart';
import 'package:untitled/widgets/mix_widgets.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
        title: const Text('AuthView'),
        centerTitle: true,
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.to(() => const RegistrationView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: wText('Registration', color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
