import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends GetConnect {

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isLogin') ?? false;
    update();
  }

  void setSignIn(bool value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSignedIn = value;
    prefs.setBool('isLogin', value);
    update();
  }



  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  void update() {
    checkSignIn();
  }



}
