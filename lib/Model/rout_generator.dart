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
      case Screen.PRESENTATION:
        return UserPreferences.getPresentationSeen() == false ||
                UserPreferences.getPresentationSeen() == null
            ? MaterialPageRoute(builder: (_) => OnboardingScreen())
            : MaterialPageRoute(builder: (_) => HomeScreen());
      case Screen.LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Screen.HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Screen.SET_APPOINTMENT:
        /* testing
         if (_authFirebase.currentUser == null) {
          // no user logged in
          return MaterialPageRoute(builder: (_) => LoginScreen());
        } else {
          print("Loggedin: ${_authFirebase.currentUser.phoneNumber}"); */
          
          return MaterialPageRoute(builder: (_) => AppointmentScreen());
        //}
    }
  }
}

class Screen {
  static const String PRESENTATION = "/";
  static const String LOGIN = "/login";
  static const String HOME = "/login/home";
  static const String SET_APPOINTMENT = "/login/home/set-appointment";
}

// Presentation only show the first time, later on login add button to go over it again
// Firebase services, Cachear en json durante 2 semanas?
// Firebase appointment data
//

//info
//https://www.youtube.com/watch?v=nyvwx7o277U
//https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df
//https://medium.com/fabcoding/navigating-between-screens-in-flutter-navigator-named-routes-passing-data-e3deab46c9e6
