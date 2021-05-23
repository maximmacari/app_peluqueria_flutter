import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authFirebase = FirebaseAuth.instance;

  void _signOut() async {
    await _authFirebase.signOut();
    Navigator.of(context).pushNamed(Screen.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).pushNamed(Screen.SET_APPOINTMENT)
        },
        child:  Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[Icon(Icons.schedule), Text("Cita")],
              ),
      ),
    );
  }

  //List services
  //Firebase servicios


}
