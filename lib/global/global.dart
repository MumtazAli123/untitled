

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
String? uid;


final FirebaseAuth fAuth = FirebaseAuth.instance;

final String currentUserID = fAuth.currentUser!.uid;

