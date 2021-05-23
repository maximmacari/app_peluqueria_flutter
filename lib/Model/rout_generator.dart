import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/View/home_screen.dart';
import 'package:flutter_sms_auth1/View/login_screen.dart';
import 'package:flutter_sms_auth1/View/onboarding_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Screen.PRESENTATION:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case Screen.LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Screen.HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Screen.SET_APPOINTMENT:
        return null;
    }
  }
}

class Screen {
  static const String PRESENTATION = "/";
  static const String LOGIN = "/login";
  static const String HOME = "/login/home";
  static const String SET_APPOINTMENT = "/login/home/set-appointment";
}

//info
//https://www.youtube.com/watch?v=nyvwx7o277U
//https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df