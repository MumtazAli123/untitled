// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:get/get.dart';
import 'package:untitled/app/modules/auth/views/mob_auth_view.dart';
import 'package:untitled/splash/splash_screen.dart';
import 'package:untitled/widgets/phone.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/budget/bindings/budget_binding.dart';
import '../modules/budget/views/budget_view.dart';
import '../modules/counter/bindings/counter_binding.dart';
import '../modules/counter/views/counter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      // page: () => LayoutBuilder(builder: (context, constraints) {
      //   if (constraints.maxWidth > 900) {
      //     return const HomeView();
      //   } else {
      //     return const MobView();
      //   }
      // }),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.COUNTER,
      page: () => const CounterView(),
      binding: CounterBinding(),
    ),
    GetPage(
      name: _Paths.BUDGET,
      page: () => const BudgetView(),
      binding: BudgetBinding(),
    ),
    GetPage(
      name: _Paths.Login,
      page: () => MobAuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PHONE,
      page: () => PhoneView(),
      binding: AuthBinding(),
    ),
  ];
}
