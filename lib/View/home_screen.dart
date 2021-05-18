import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'login_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

final _authFirebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {

        },
        child: Icon(Icons.logout),
      ),
    );
  }

  void _signOut() async{
    await _authFirebase.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}