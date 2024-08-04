// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class AnimationView extends GetView<AnimatedContainer> {
  const AnimationView({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Animation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: 500,
            width: double.infinity,
            child: Lottie.asset('assets/lottie/enjoy.json'),
          ),
        ),
      ),
    );
  }
}
