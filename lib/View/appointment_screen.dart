import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Shared/colors.dart';
import 'package:flutter_sms_auth1/ViewModel/home_vm.dart';
import 'package:flutter_sms_auth1/Shared/custom_extensions.dart';
import 'package:flutter_sms_auth1/Shared/styles.dart';
import 'package:flutter_sms_auth1/ViewModel/appointment_vm.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AppointmentObservable>(context, listen: false)
        .getMoriningRangeTimes();
    Provider.of<AppointmentObservable>(context, listen: false)
        .getAfternoonRangeTimes();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("es_ES");
    var appointmentObservable =
        Provider.of<AppointmentObservable>(context, listen: false); //true
    var homeObservable = Provider.of<HomeObservable>(context, listen: false);
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (screenSizeHeight - kToolbarHeight - 24) / 10;
    final double itemWidth = screenSizeWidth / 1.8;

    //print("Servicenames_ ${homeObservable.servicesNames}"); // TODO test, now its empty[]
    print("Rendering AppointmentScreen");

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
                                color: appointmentObservable
                                        .isDateAccesibleBackward
                                    ? ConstantColors.mainColorApp
                                    : ConstantColors.btnDisabled,
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
                                color:
                                    appointmentObservable.isDateAccesibleForward
                                        ? ConstantColors.mainColorApp
                                        : ConstantColors.btnDisabled,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerWidget(
                        "Servicio: ${appointmentObservable.selectedSalonService.name.capitalized()}"),
                    DropdownButton<SalonService>(
                      isExpanded: true,
                      focusColor: ConstantColors.myWhite,
                      style: TextStyle(color: ConstantColors.myWhite),
                      iconEnabledColor: ConstantColors.myBlack,
                      onChanged: (SalonService service) {
                        appointmentObservable.selectedService = service;
                      },
                      value: null,
                      items: homeObservable.servicesList
                          .toSet()
                          .toList()
                          .map<DropdownMenuItem<SalonService>>(
                              (SalonService service) {
                        if (appointmentObservable.auxSubgroup
                                .toLowerCase()
                                .toString() !=
                            service.subgroup.toLowerCase().toString()) {
                          appointmentObservable.auxSubgroup = service.subgroup;
                          return DropdownMenuItem<SalonService>(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: ConstantColors.mainColorApp
                                    .withOpacity(0.7),
                              ),
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              child: Text(
                                service.subgroup.capitalized(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ConstantColors.myBlack,
                                ),
                              ),
                            ),
                          );
                        }
                        return DropdownMenuItem<SalonService>(
                            value: service,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Text(
                                  service.name,
                                  style:
                                      TextStyle(color: ConstantColors.myBlack),
                                ),
                              ),
                            ));
                      }).toList(),
                      hint: Text(
                        "¿Qué te vas a hacer?",
                        style: TextStyle(
                            color: ConstantColors.myBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
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
                      appointmentObservable.morningDateTimeRanges.length > 0
                          ? GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: appointmentObservable
                                  .morningDateTimeRanges.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      crossAxisCount:
                                          (screenSizeWidth / itemWidth)
                                              .ceil()
                                              .toInt(),
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemBuilder: (BuildContext context, int index) {
                                return _buttonTimeWidget(appointmentObservable
                                    .morningDateTimeRanges[index]);
                              },
                            )
                          : Text("No hay citas disponibles", style: TextStyle(color: Colors.grey),),
                      _headerWidget("Tarde"),
                      appointmentObservable.afternoonDateTimeRanges.length > 0
                          ? GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: context
                                  .read<AppointmentObservable>()
                                  .afternoonDateTimeRanges
                                  .length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      crossAxisCount:
                                          (screenSizeWidth / itemWidth)
                                              .ceil()
                                              .toInt(),
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemBuilder: (BuildContext context, int index) {
                                return _buttonTimeWidget(appointmentObservable
                                    .afternoonDateTimeRanges[index]);
                              },
                            )
                          : Text("No hay citas disponibles", style: TextStyle(color: Colors.grey),),
                    ],
                  )),
              SizedBox(height: 32),
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
  Widget _buttonTimeWidget(DateTimeRange timeRange) {
    var appointmentObservable =
        Provider.of<AppointmentObservable>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          color: appointmentObservable.selectedTimeRange == timeRange
              ? ConstantColors.mainColorApp
              : ConstantColors.myWhite,
          border: Border.all(
              color: ConstantColors.myBlack,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12)),
      child: TextButton(
          onPressed: () {
            appointmentObservable.selectedTimeRange = timeRange;
          },
          child: Text(timeRange.toHourString(),
              maxLines: 1,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.foregroundTxtButtonColor,
                  fontSize: 14))),
    );
  }

  Widget _headerWidget(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text("$text",
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
        if (appointmentObservable.isDayAvailable(this.dateTime)) {
          appointmentObservable.selectedDate = dateTime;
          appointmentObservable.getAfternoonRangeTimes();
          appointmentObservable.getMoriningRangeTimes();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: (appointmentObservable.isDayAvailable(this.dateTime))
                ? Theme.of(context).colorScheme.foregroundPlainTxtColor
                : ConstantColors.btnDisabled,
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
                style: TextStyle(
                    color: (appointmentObservable.isDayAvailable(this.dateTime))
                        ? Theme.of(context).colorScheme.foregroundPlainTxtColor
                        : ConstantColors.btnDisabled)),
            Container(
                padding: EdgeInsets.all(8),
                child: Text(dateTime.day.toString(),
                    style: TextStyle(
                        color: (appointmentObservable
                                .isDayAvailable(this.dateTime))
                            ? Theme.of(context)
                                .colorScheme
                                .foregroundPlainTxtColor
                            : ConstantColors.btnDisabled))),
          ],
        ),
      ),
    );
  }
}
