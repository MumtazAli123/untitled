import 'package:get/get.dart';

import 'package:untitled/app/modules/animation/bindings/animation_binding.dart';
import 'package:untitled/app/modules/animation/views/animation_view.dart';
import 'package:untitled/app/modules/auth/views/mob_auth_view.dart';
import 'package:untitled/app/modules/notification/bindings/notification_binding.dart';
import 'package:untitled/app/modules/notification/views/notification_view.dart';
import 'package:untitled/app/modules/profile/bindings/profile_binding.dart';
import 'package:untitled/app/modules/profile/views/profile_view.dart';
import 'package:untitled/app/modules/register/bindings/register_binding.dart';
import 'package:untitled/app/modules/tab_screens/bindings/tab_screens_binding.dart';
import 'package:untitled/app/modules/tab_screens/views/tab_screens_view.dart';
import 'package:untitled/splash/splash_screen.dart';
import 'package:untitled/widgets/phone.dart';

import '../../models/user_model.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/budget/bindings/budget_binding.dart';
import '../modules/budget/views/budget_view.dart';
import '../modules/counter/bindings/counter_binding.dart';
import '../modules/counter/views/counter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_map_view.dart';
import '../modules/register/views/register_screen.dart';

// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeMapView(),
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
      page: () => BudgetView(
        loggedInUser: UserModel(),
      ),
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
    GetPage(
      name: _Paths.ANIMATION,
      page: () => AnimationView(),
      binding: AnimationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TAB_SCREENS,
      page: () => TabScreensView(),
      binding: TabScreensBinding(),
    ),
  ];
}
