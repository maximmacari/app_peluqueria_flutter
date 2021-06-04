import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/Shared/alert_dialog.dart';
import 'package:flutter_sms_auth1/ViewModel/home_vm.dart';
import "package:flutter_sms_auth1/Shared/colors.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sms_auth1/Shared/custom_extensions.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeObservable>(context, listen: false).initHome(context);
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        print("state: paused");
        /* Provider.of<LoginObservable>(context, listen: false)
            .authService
            .signOut(); */
        break;
      case AppLifecycleState.resumed:
        print("state: resumed");
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
        print("state: inactive");
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        print("state: detached");

        break;
    }
  }

  Widget build(BuildContext context) {
    final String _selectedSubgroup = UserPreferences.getSelectedSubGroup();

    print("Rendering home screen");
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedSubgroup.capitalized(),
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.foregroundPlainTxtColor)),
          foregroundColor:
              Theme.of(context).colorScheme.foregroundPlainTxtColor,
          backgroundColor: ConstantColors.mainColorApp,
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.blue.withAlpha(200),
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
                icon: Icon(Icons.info_outlined,
                    color:
                        Theme.of(context).colorScheme.foregroundTxtButtonColor),
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
          label: Text('Reservar',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.foregroundTxtButtonColor)
              //ConstantColors.foregroundColorButton), // EEn dark foregroundcolorButton: Colors.white, light foreegroundcolorButton: Colors.nomuydark
              ),
          onPressed: () {
            Navigator.of(context).pushNamed(Screen.SET_APPOINTMENT);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Consumer<HomeObservable>(builder: (context, data, _) {
          if (data.servicesList.length > 0) {
            return Column(
              children: [
                HorizontalScrollViewSubgroups(),
                VerticalCustomListView()
              ],
            );
          } else {
            return CircularIndicatorAlertDialog();
          }
        }));
  }
}

class HorizontalScrollViewSubgroups extends StatefulWidget {
  HorizontalScrollViewSubgroups() {}

  @override
  _HorizontalScrollViewSubgroupsState createState() =>
      _HorizontalScrollViewSubgroupsState();
}

class _HorizontalScrollViewSubgroupsState
    extends State<HorizontalScrollViewSubgroups> {
  @override
  Widget build(BuildContext context) {
    var homeObservable = Provider.of<HomeObservable>(context, listen: true);
    return Container(
        padding: EdgeInsets.all(8),
        color: Theme.of(context).colorScheme.mainBackground,
        child: CarouselSlider(
            options: CarouselOptions(
                autoPlay: false,
                aspectRatio: 16 / 9,
                initialPage: 0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) {
                  homeObservable.selectedSubgroup =
                      homeObservable.servicesList[index].subgroup;
                  print("selectedsubgroup: ${homeObservable.selectedSubgroup}");
                }),
            items: homeObservable.servicesList.getUniqueSubgroup().map((service) => Container(
                      decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: service.subgroupColor.withOpacity(0.06),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(-2, -2)),
                            BoxShadow(
                                color: service.subgroupColor.withOpacity(0.06),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(2, 2))
                          ],
                          color: Theme.of(context).colorScheme.mainBackground,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  service.subgroupColor.withOpacity(0.32),
                                  BlendMode.softLight),
                              image: AssetImage(
                                  "assets/images/${service.subgroup}_background.jpg"),
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
                                    service.subgroup.toString().capitalized(),
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
                                        "assets/icons/${service.subgroup}.svg",
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
                    ))
                .toList()));
  }
}

class VerticalCustomListView extends StatelessWidget {
  VerticalCustomListView() {}
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            color: Theme.of(context).colorScheme.mainBackground,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.mainBackground,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Consumer<HomeObservable>(
                    builder: (context, data, _) => Column(
                        children: listaItems(data.servicesList
                            .filterBySubgroupName(data.selectedSubgroup))),
                  ),
                ),
              )
            ])));
  }
}

List<Widget> listaItems(List<SalonService> _subgroupServices) {
  return _subgroupServices.map((element) => serviceRow(element)).toList();
}

Widget serviceRow(SalonService salonService) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: FittedBox(
          child: Text(
            "${salonService.name.capitalized()}",
            maxLines: 1,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "CormorantGaramond"),
          ),
        ),
      ),
      Spacer(
        flex: 1,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        child: Text(
          "${salonService.price} €",
          maxLines: 1,
          style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: "CormorantGaramond"),
        ),
      ),
    ],
  );
}
