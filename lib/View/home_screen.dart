import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/shared/alert_dialog.dart';
import "package:flutter_sms_auth1/shared/colors.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter_sms_auth1/shared/custom_extensions.dart';
import "package:carousel_slider/carousel_slider.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authFirebase = FirebaseAuth.instance;

  List<SalonService> _servicesList = [];
  String _selectedSubgroup = "cortes";

  callback(newSubgroup) {
    setState(() {
      _selectedSubgroup = newSubgroup;
    });
  }

  @override
  void initState() {
    super.initState();
    //read json if exist, if not request it
    readHairdressingServicesJson();
    readEstheticServicesJson();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedSubgroup.capitalized(),
            style:
                TextStyle(color: Theme.of(context).colorScheme.foregroundPlainTxtColor)),
        
        foregroundColor: Theme.of(context).colorScheme.foregroundPlainTxtColor,
        backgroundColor: ConstantColors.mainColorApp,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(200),
            borderRadius: BorderRadius.circular(50)
          ),
          child: IconButton(
              icon: Icon(Icons.info_outlined,
                  color: Theme.of(context).colorScheme.foregroundTxtButtonColor),
              onPressed: () {
                UserPreferences.setPresentationSeen(false);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Screen.PRESENTATION, (route) => false);
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ConstantColors.mainColorApp,
        elevation: 4.0,
        //shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 1)),
        icon: Icon(
          Icons.add,
          //color: Theme.of(context).colorScheme.mainForeground
        ),
        label: Text(
          'Reservar',
          style: TextStyle(
              color: Theme.of(context).colorScheme.foregroundTxtButtonColor)
              //ConstantColors.foregroundColorButton), // EEn dark foregroundcolorButton: Colors.white, light foreegroundcolorButton: Colors.nomuydark
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Screen.SET_APPOINTMENT);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: (_servicesList as List<SalonService>).length > 0
          ? Column(
              children: [
                HorizontalScrollViewSubgroups(
                    _servicesList.getUniqueSubgroup(), callback),
                VerticalCustomListView(
                    _servicesList.filterBySubgroupName(_selectedSubgroup))
              ],
            )
          : CircularProgressIndicator(),
    );
  }

  void updateSelecteeedSubgroup(String newSubgroup) {
    setState(() {
      this._selectedSubgroup = newSubgroup;
    });
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
  List<SalonService> _services = [];
  Function(String) callback;

  HorizontalScrollViewSubgroups(services, Function func) {
    this._services = services;
    callback = func;
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
      color: Theme.of(context).colorScheme.mainBackground,
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView.separated(
          separatorBuilder: (ctx, index) => SizedBox(
                width: 8,
              ),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          itemCount: widget._services.length,
          itemBuilder: (context, index) {
            return widget._services.length > 0
                ? InkWell(
                    onTap: () {
                      setState(() {
                        widget.callback(widget._services[index].subgroup);
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: widget._services[index].subgroupColor
                                    .withOpacity(0.06),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(-2, -2)),
                            BoxShadow(
                                color: widget._services[index].subgroupColor
                                    .withOpacity(0.06),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(2, 2))
                          ],
                          color: Theme.of(context).colorScheme.mainBackground,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  widget._services[index].subgroupColor
                                      .withOpacity(0.32),
                                  BlendMode.softLight),
                              image: AssetImage(
                                  "assets/images/${widget._services[index].subgroup}_background.jpg"),
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
                                    widget._services[index].subgroup
                                        .toString()
                                        .capitalized(),
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
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/icons/${widget._services[index].subgroup}.svg",
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
                  )
                : CircularProgressIndicator();
          }),
    );
  }
}

class VerticalCustomListView extends StatelessWidget {
  List<SalonService> _subgroupServices = [];

  VerticalCustomListView(List subgroupServices) {
    this._subgroupServices = subgroupServices;
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Theme.of(context).colorScheme.mainBackground,
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
          itemCount: _subgroupServices.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.mainBackground,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
                    child: Text(
                      "${_subgroupServices[index].name.capitalized()}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "CormorantGaramond"),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                    child: Text(
                      "${_subgroupServices[index].price} €",
                      style: TextStyle(
                        letterSpacing: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "CormorantGaramond"),
                    ),
                  ),
                ],
              ),
            );
          }),
    ));
  }
}
