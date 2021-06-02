
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/Shared/colors.dart';
import 'package:flutter_sms_auth1/ViewModel/home_vm.dart';
import 'package:flutter_sms_auth1/ViewModel/login_vm.dart';
import 'package:flutter_sms_auth1/ViewModel/onboarding_vm.dart';
import 'package:flutter_sms_auth1/ViewModel/appointment_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.initPrefs();
  runApp(MainPageApp());
}

class MainPageApp extends StatelessWidget {
  // This widget is the root of your application.

  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardingObservable()),
        ChangeNotifierProvider(create: (context) => LoginObservable()),
        ChangeNotifierProvider(create: (context) => HomeObservable()),
        ChangeNotifierProvider(create: (context) => AppointmentObservable())
      ],
      child: MaterialApp(
        title: 'Peluqeria',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.light(), textSelectionTheme: TextSelectionThemeData(
            selectionColor: Color(0xffBA379B).withOpacity(.5),
            cursorColor: ConstantColors.mainColorApp.withOpacity(0.7),
            selectionHandleColor: ConstantColors.mainColorApp.withOpacity(0.7),
          ),),
        initialRoute: Screen.SET_APPOINTMENT,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}


class AppLifecycleReactor extends StatefulWidget {
  const AppLifecycleReactor({ Key key }) : super(key: key);

  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Last notification: $_notification');
  }
}