import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/shared/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authFirebase = FirebaseAuth.instance;

  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/hairdressing.json');

      final hairdressingObjectJson = jsonDecode(response)["Peluqueria"] as List;
      //print("$hairdressingObjectJson");
      setState(() {
        //_items = data["Peluqueria"];
      _items = SalonServiceList.fromJson(hairdressingObjectJson).salonServices;
      print(_items);
      });
    } catch (err) {
      OkAlertDialog("Error", "Ha ahbido un error: ${err.toString()}",
          () => Navigator.of(context).pop("ok"));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Servicios',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Load Data'),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            _items.length > 0
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                          child: ListTile(
                            leading: Text(_items[index].toString()),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    await _authFirebase.signOut();
    Navigator.of(context).pushNamed(Screen.LOGIN);
  }
}

/* Row(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[Icon(Icons.schedule), Text("Reservar cita")],
                ), */
