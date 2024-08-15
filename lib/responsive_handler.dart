// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:untitled/app/modules/auth/views/auth_view.dart';
import 'package:untitled/app/modules/home/views/home_view.dart';
import 'package:untitled/view_model.dart';
import 'package:provider/provider.dart';

import 'app/modules/auth/views/mob_auth_view.dart';
import 'app/modules/home/views/home_map_view.dart';

class ResponsiveHandler extends  StatelessWidget{
  const ResponsiveHandler({super.key});

  @override
  Widget build(BuildContext context){
    final viewModelProvider = Provider.of<ViewModel>(context);
    viewModelProvider.isLoggedIn();

    if (viewModelProvider.isSignIn == true) {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return HomeView();
        } else {
          return HomeMapView();
        }
      });
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return AuthView();
        } else {
          return MobAuthView();
        }
      });
    }
  }
}
