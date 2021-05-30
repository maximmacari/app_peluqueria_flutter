import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/ViewModel/home_vm.dart';
import 'package:flutter_sms_auth1/ViewModel/onboarding_vm.dart';
import 'package:flutter_sms_auth1/ViewModel/appointment_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardingObservable()),
        ChangeNotifierProvider(create: (context) => HomeObservable()),
        ChangeNotifierProvider(create: (context) => AppointmentObservable())
      ],
      child: MaterialApp(
        title: 'Peluqeria',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.light()),
        initialRoute: Screen.SET_APPOINTMENT,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
