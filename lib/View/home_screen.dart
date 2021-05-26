import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/shared/alert_dialog.dart';
import 'package:flutter_sms_auth1/shared/styles.dart';
import "package:flutter_sms_auth1/shared/colors.dart";
import 'package:flutter_svg/flutter_svg.dart';
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
    //print(_servicesList);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Servicios"),
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
                    HorizontalScrollViewSubgroups(_servicesList),
                    //Vertical grid with headers
                    //Stagered vGrid
                    //medium.com / flutterdevs staggered gridview on flutter
                    VerticalGridWaterfall()
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

class HorizontalScrollViewSubgroups extends StatefulWidget {
  List _services = [];
  List _uniqueServices = [];

  HorizontalScrollViewSubgroups(services) {
    this._services = services;
    this._uniqueServices = _services;
    final aux = this._services.map((e) => e.subgroup).toSet();
    _uniqueServices.retainWhere((element) => aux.remove(element.subgroup));
  }

  @override
  _HorizontalScrollViewSubgroupsState createState() =>
      _HorizontalScrollViewSubgroupsState();
}

class _HorizontalScrollViewSubgroupsState
    extends State<HorizontalScrollViewSubgroups> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView.separated(
          separatorBuilder: (ctx, index) => SizedBox(
                width: 8,
              ),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          itemCount: widget._uniqueServices.length,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.55,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: widget._uniqueServices[index].subgroupColor
                          .withOpacity(0.6),
                      spreadRadius: -5,
                      blurRadius: 8,
                      offset: Offset(-2, -2)),
                  BoxShadow(
                      color: widget._uniqueServices[index].subgroupColor
                          .withOpacity(0.4),
                      spreadRadius: -2,
                      blurRadius: 8,
                      offset: Offset(2, 2))
                ]),
                child: Card(
                  child: Container(
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                widget._uniqueServices[index].subgroupColor,
                                BlendMode.softLight),
                            image: AssetImage(
                                "assets/images/${widget._uniqueServices[index].subgroup}_background.jpg"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Text(
                                  widget._uniqueServices[index].subgroup
                                      .toString()
                                      .capitalize(),
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 5.0,
                                            color: Color(0xFF111111)),
                                        Shadow(
                                            offset: Offset(-1, -1),
                                            blurRadius: 2,
                                            color: Color(0xFF010101)),
                                      ]),
                                ),
                              ),
                              Spacer(flex: 1)
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/${widget._uniqueServices[index].subgroup}.svg",
                                      height: 40,
                                      width: 40,
                                    ),
                                  )),
                              Spacer()
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                ));
          }),
    );
  }
}

class VerticalGridWaterfall extends StatefulWidget {
  @override
  _VerticalGridWaterfallState createState() => _VerticalGridWaterfallState();
}

class _VerticalGridWaterfallState extends State<VerticalGridWaterfall> {
  List<String> _subgroupedServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid Header Demo"),
      ),
      body: gridHeader(),
    );
  }

  Widget gridHeader() {
    return new ListView.builder(
      itemCount: _subgroupedServices.length,
      itemBuilder: (context, index) {
        return Spacer();
      },
      shrinkWrap: true,
    );
  }
}
