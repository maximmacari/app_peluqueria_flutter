import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/View/appointment_screen.dart';
import 'package:flutter_sms_auth1/View/home_screen.dart';
import 'package:flutter_sms_auth1/View/login_screen.dart';
import 'package:flutter_sms_auth1/View/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments; // data passed to other views
    final _authFirebase = FirebaseAuth.instance;
    switch (settings.name) {
      case Screen.LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Screen.HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Screen.SET_APPOINTMENT:
        if (_authFirebase.currentUser == null) {// no user logged in 
          return MaterialPageRoute(builder: (_) => LoginScreen());
        } else {
          print("Logged in: ${_authFirebase.currentUser.phoneNumber}");
          return MaterialPageRoute(builder: (_) => AppointmentScreen());
        }
        break;
      default:
        return UserPreferences.getPresentationSeen() == false ||
                UserPreferences.getPresentationSeen() == null
            ? MaterialPageRoute(builder: (_) => OnboardingScreen())
            : MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}

class Screen {
  static const String PRESENTATION = "/";
  static const String LOGIN = "/login";
  static const String HOME = "/login/home";
  static const String SET_APPOINTMENT = "/login/home/set-appointment";
}
