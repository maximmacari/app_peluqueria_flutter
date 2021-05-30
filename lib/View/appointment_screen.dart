import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_sms_auth1/ViewModel/home_vm.dart';
import 'package:flutter_sms_auth1/shared/colors.dart';
import 'package:flutter_sms_auth1/shared/styles.dart';
import 'package:flutter_sms_auth1/ViewModel/appointment_vm.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    var appointmentObservable = Provider.of<AppointmentObservable>(context);
    var homeObservable = Provider.of<HomeObservable>(context);
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (screenSizeHeight - kToolbarHeight - 24) / 10;
    final double itemWidth = screenSizeWidth / 1.8;

    print(homeObservable.servicesNames); // TODO test, now its empty[]
    initializeDateFormatting("es_ES");

    return Scaffold(
      backgroundColor: ConstantColors.mainColorApp,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.chevron_left,
                color: Theme.of(context).colorScheme.foregroundTxtButtonColor),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Reserva una cita",
          style: TextStyle(
              color: Theme.of(context).colorScheme.foregroundPlainTxtColor),
        ),
      ),
      body: Container(
        width: screenSizeWidth,
        height: screenSizeHeight,
        color: ConstantColors.myWhite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: ConstantColors.myWhite,
                  width: screenSizeWidth,
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            appointmentObservable.previousMonth();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: appointmentObservable.isDateAccesibleBackward
                                    ? ConstantColors.mainColorApp
                                    : ConstantColors.mainColorApp
                                        .withOpacity(0.24),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.chevron_left,
                              color: ConstantColors.myBlack,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(appointmentObservable.montAndYear(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .foregroundPlainTxtColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                        InkWell(
                          onTap: () {
                             appointmentObservable.nextMonth();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: appointmentObservable.isDateAccesibleForward
                                    ? ConstantColors.mainColorApp
                                    : ConstantColors.mainColorApp
                                        .withOpacity(0.24),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.chevron_right,
                              color: ConstantColors.myBlack,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: appointmentObservable
                            .daysInMonth()
                            .map((currentDate) {
                          return DateColumn(dateTime: currentDate);
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 15),
                  ])),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButton<String>(
                  isExpanded: true,
                  focusColor: ConstantColors.myWhite,
                  value: appointmentObservable.selectedServiceName,
                  //elevation: 5,
                  style: TextStyle(color: ConstantColors.myWhite),
                  iconEnabledColor: ConstantColors.myBlack,
                  items: homeObservable.servicesNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: ConstantColors.myBlack),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Que te vas a hacer",
                    style: TextStyle(
                        color: ConstantColors.myBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    appointmentObservable.selectedServiceName = value;
                  },
                ),
              ),
              Container(
                  width: screenSizeWidth,
                  color: ConstantColors.myWhite,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _headerWidget("Madrugada"),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount:
                                (screenSizeWidth / itemWidth).ceil().toInt(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (BuildContext context, int index) {
                          return _buttonTimeWidget("10:30 - 11:45");
                        },
                      ),
                      _headerWidget("Tarde"),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount:
                                (screenSizeWidth / itemWidth).ceil().toInt(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (BuildContext context, int index) {
                          return _buttonTimeWidget("6");
                        },
                      ),
                    ],
                  )),
              SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Reservar",
                    style: CustomTextStyles().onboardingBtnTextStyle(context),
                  ),
                  style: TextButton.styleFrom(
                      shape: (RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      backgroundColor: ConstantColors.mainColorApp),
                ),
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }

  //buttonTime
  Widget _buttonTimeWidget(timeText) {
    return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(timeText,
            maxLines: 1,
            style: TextStyle(
                color: Theme.of(context).colorScheme.foregroundTxtButtonColor,
                fontSize: 14)));
  }

  Widget _headerWidget(String text) {
    return Column(
      children: [
        SizedBox(height: 24),
        Text("$text: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16)
      ],
    );
  }
}

class AvaiableTimeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DateColumn extends StatelessWidget {
  final DateTime dateTime;

  const DateColumn({Key key, this.dateTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appointmentObservable =
        Provider.of<AppointmentObservable>(context, listen: false);

    bool _isDateColumnPicked() {
      return this.dateTime.day == appointmentObservable.selectedDate.day;
    }

    return InkWell(
      onTap: () {
        appointmentObservable.selectedDate = dateTime;
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _isDateColumnPicked()
              ? ConstantColors.mainColorApp
              : ConstantColors.myWhite,
        ),
        child: Column(
          children: <Widget>[
            Text(appointmentObservable.dayName(dateTime),
                style: TextStyle(color: ConstantColors.myBlack)),
            Container(
                padding: EdgeInsets.all(8),
                child: Text(dateTime.day.toString(),
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .foregroundPlainTxtColor))),
          ],
        ),
      ),
    );
  }
}
