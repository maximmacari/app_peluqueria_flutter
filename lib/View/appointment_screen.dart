import "package:flutter/material.dart";

//change bakcgorund color: White dark
//https://www.uplabs.com/search?q=barber
//https://github.com/JoanNabusoba/flutter-salon-app/blob/master/lib/pages/book.dart
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Appointment screen"),
      ),
    );
  }
}

