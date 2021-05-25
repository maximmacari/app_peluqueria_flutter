import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/shared/alert_dialog.dart';
import 'package:flutter_sms_auth1/shared/styles.dart';
import "package:flutter_sms_auth1/shared/colors.dart";
import 'dart:convert';
import 'package:flutter_sms_auth1/shared/custom_extensions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authFirebase = FirebaseAuth.instance;

  List _servicesList = [];

  @override
  void initState() {
    super.initState();
    //read json if exist, if not request it
    readHairdressingServicesJson();
    readEstheticServicesJson();
    print(_servicesList);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.info_outlined,
                color: Theme.of(context).colorScheme.mainForeground),
            onPressed: () {
              UserPreferences.setPresentationSeen(false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Screen.PRESENTATION, (route) => false);
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.mainBackground,
        elevation: 4.0,
        icon: Icon(Icons.add,
            color: Theme.of(context).colorScheme.mainForeground),
        label: Text(
          'Reservar',
          style: CustomTextStyles().onboardingBtnTextStyle(context),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Screen.SET_APPOINTMENT);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: _servicesList.length > 0
              ? Column(
                  children: [
                    VerticalScrollViewSubgroups(_servicesList),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _servicesList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                            child: ListTile(
                              leading: Text(""),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : Container()),
    );
  }

  // Fetch content from the json file
  Future<void> readHairdressingServicesJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/saved-files/hairdressing.json');
      final hairdressingObjectJson = jsonDecode(response)["Peluqueria"] as List;
      setState(() {
        _servicesList.addAll(
            SalonServiceList.fromJson(hairdressingObjectJson).salonServices);
      });
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => Navigator.of(context).pop("ok"));
    }
  }

  // Fetch content from the json file
  Future<void> readEstheticServicesJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/saved-files/esthetic.json');
      final _estheticObjectJson = jsonDecode(response)["Estetica"] as List;
      setState(() {
        _servicesList.addAll(
            SalonServiceList.fromJson(_estheticObjectJson).salonServices);
      });
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => Navigator.of(context).pop("ok"));
    }
  }

  //Not really needed
  Future<void> _signOut() async {
    try {
      if (_authFirebase.currentUser != null) {
        await _authFirebase.signOut();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Screen.LOGIN, (route) => false);
      }
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => {Navigator.of(context).pop()});
    }
  }
}

class VerticalScrollViewSubgroups extends StatefulWidget {
  List _services = [];
  List _subGroups = [];

  VerticalScrollViewSubgroups(@required services) {
    this._services = services;
    _subGroups =
        (this._services.map((e) => e.subgroup.toString()).toSet().toList());
  }

  @override
  _VerticalScrollViewSubgroupsState createState() =>
      _VerticalScrollViewSubgroupsState();
}

class _VerticalScrollViewSubgroupsState
    extends State<VerticalScrollViewSubgroups> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget._subGroups.length,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  child: Container(
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.6),
                                BlendMode.softLight),
                            image: AssetImage(
                                "assets/images/${widget._subGroups[index]}_background.jpg"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Text(
                      widget._subGroups[index],
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    )),
                  ),
                ));
          }),
    );
  }
}
