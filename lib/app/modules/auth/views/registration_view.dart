// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:untitled/app/modules/auth/controllers/auth_controller.dart';

import '../../../../widgets/mix_widgets.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {

  final controller = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // controller.isLoading.value = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration '),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/auth');
            },
            icon: const Icon(Icons.lock, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              controller.streamArticle();
            },
            icon: controller.isRefresh.value
                ? const Icon(Icons.refresh, color: Colors.green)
                : const Icon(Icons.refresh_outlined, color: Colors.red),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 450,
              child: Form(
                key: _formKey,
                child:
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    wTextFormFiled('Name', Icons.person, nameController, TextInputType.text),
                    const SizedBox(height: 20.0),
                    wTextFormFiled('Email', Icons.email, emailController, TextInputType.emailAddress),
                    const SizedBox(height: 20.0),
                    wTextFormFiled('Phone', Icons.phone, phoneController, TextInputType.phone),
                    const SizedBox(height: 20.0),
                    wTextFormFiled('Address', Icons.location_on, addressController, TextInputType.text),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: controller.isLoading.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.togglePassword();
                          },
                          icon: Icon(controller.isLoading.value ? Icons.visibility : Icons.visibility_off),
                        ),
                        hintText: 'Password',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.register(
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            addressController.text,
                            passwordController.text,
                          );
                          _formKey.currentState!.reset();

                        }else{
                          Get.snackbar('Error', 'Please fill all fields');
                        }
                        Get.toNamed('/auth');
                      },
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/auth');
                          },
                          child: const Text('Login', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
          SizedBox(height: 60.0),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),

        ],
      ),
    );
  }

  togglePassword() {
    controller.isLoading.value = !controller.isLoading.value;

  }
}
