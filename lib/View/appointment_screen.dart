import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_sms_auth1/Model/appointment.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import 'package:flutter_sms_auth1/Shared/alert_dialog.dart';
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
  AppointmentObservable appointmentObservable;

  @override
  void initState() {
    appointmentObservable =
        Provider.of<AppointmentObservable>(context, listen: false); //true
    appointmentObservable.getReservations();
    appointmentObservable.getMoriningRangeTimes();
    appointmentObservable.getAfternoonRangeTimes();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("es_ES");
    //var appointmentObservable = Provider.of<AppointmentObservable>(context, listen: false); //true
    var homeObservable = Provider.of<HomeObservable>(context, listen: false);
    appointmentObservable.selectedSalonService = homeObservable.servicesList
        .where((element) => element.id == "210")
        .toList()[0];

    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (screenSizeHeight - kToolbarHeight - 24) / 10;
    final double itemWidth = screenSizeWidth / 1.8;

    print("Rendering AppointmentScreen");
    return Scaffold(
        backgroundColor: ConstantColors.mainColorApp,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.chevron_left,
                  color:
                      Theme.of(context).colorScheme.foregroundTxtButtonColor),
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
          child: appointmentObservable.afternoonDateTimeRanges == []
              ? CircularIndicatorAlertDialog()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Container(
                      width: screenSizeWidth,
                      color: ConstantColors.myWhite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              color: ConstantColors.myWhite,
                              width: screenSizeWidth,
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        appointmentObservable.previousMonth();
                                      },
                                      child: Consumer<AppointmentObservable>(
                                          builder: (context, data, _) {
                                        return Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: data
                                                      .isDateAccesibleBackward
                                                  ? ConstantColors.mainColorApp
                                                  : ConstantColors.btnDisabled,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.chevron_left,
                                            color: data.isDateAccesibleBackward
                                                ? ConstantColors.myBlack
                                                : ConstantColors.myBlack
                                                    .withOpacity(0.5),
                                          ),
                                        );
                                      }),
                                    ),
                                    Expanded(
                                      child: Selector<AppointmentObservable,
                                              String>(
                                          selector: (_, provider) =>
                                              provider.monthAndYear(),
                                          builder:
                                              (context, monthAndYear, child) {
                                            return Text(monthAndYear,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .foregroundPlainTxtColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600));
                                          }),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        appointmentObservable.nextMonth();
                                      },
                                      child: Consumer<AppointmentObservable>(
                                          builder: (context, data, _) {
                                        return Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: data.isDateAccesibleForward
                                                  ? ConstantColors.mainColorApp
                                                  : ConstantColors.btnDisabled,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: data.isDateAccesibleForward
                                                ? ConstantColors.myBlack
                                                : ConstantColors.myBlack
                                                    .withOpacity(0.5),
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: appointmentObservable.showLoadingDays
                                        ? CircularProgressIndicator()
                                        : Consumer<AppointmentObservable>(
                                            builder: (context, data, _) {
                                            return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: data
                                                    .daysInMonth()
                                                    .map((currentDay) =>
                                                        DateColumn(
                                                            dateTime:
                                                                currentDay))
                                                    .toList());
                                          }),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _headerWidget("Encargo: "),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      decoration: BoxDecoration(
                                        color: ConstantColors.mainColorApp
                                            .withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Consumer<AppointmentObservable>(
                                          builder: (context,
                                              appointmentObservableData, _) {
                                        return DropdownButton<SalonService>(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: ConstantColors.myBlack,
                                          ),
                                          isExpanded: true,
                                          focusColor: ConstantColors.myWhite,
                                          style: TextStyle(
                                              color: ConstantColors.myWhite),
                                          iconEnabledColor:
                                              ConstantColors.myBlack,
                                          onChanged: (SalonService service) {
                                            appointmentObservable
                                                .selectedSalonService = service;
                                          },
                                          value: appointmentObservableData
                                              .selectedSalonService,
                                          items: homeObservable.servicesList
                                              .toSet()
                                              .toList()
                                              .map<
                                                      DropdownMenuItem<
                                                          SalonService>>(
                                                  (SalonService service) {
                                            if (appointmentObservable
                                                    .auxSubgroup
                                                    .toLowerCase()
                                                    .toString() !=
                                                service.subgroup
                                                    .toLowerCase()
                                                    .toString()) {
                                              appointmentObservable
                                                      .auxSubgroup =
                                                  service.subgroup;
                                              return DropdownMenuItem<
                                                  SalonService>(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: ConstantColors
                                                        .mainColorApp
                                                        .withOpacity(0.7),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: double.infinity,
                                                  child: Text(
                                                    service.subgroup
                                                        .capitalized(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ConstantColors
                                                          .myBlack,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return DropdownMenuItem<
                                                    SalonService>(
                                                value: service,
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 0, 8, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          service.name
                                                              .capitalized(),
                                                          style: TextStyle(
                                                              color:
                                                                  ConstantColors
                                                                      .myBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${service.price} €",
                                                          style: TextStyle(
                                                              color:
                                                                  ConstantColors
                                                                      .myBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                        );
                                      })),
                                ),
                                _headerWidget("Madrugada"),
                                appointmentObservable
                                            .morningDateTimeRanges.length >=
                                        1
                                    ? Consumer<AppointmentObservable>(
                                        builder: (context, data, _) {
                                        return GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:
                                              data.morningDateTimeRanges.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio:
                                                      (itemWidth / itemHeight),
                                                  crossAxisCount:
                                                      (screenSizeWidth /
                                                              itemWidth)
                                                          .ceil()
                                                          .toInt(),
                                                  crossAxisSpacing: 8,
                                                  mainAxisSpacing: 8),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buttonTimeWidget(data
                                                .morningDateTimeRanges[index]);
                                          },
                                        );
                                      })
                                    : Text(
                                        "No hay citas disponibles",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                _headerWidget("Tarde"),
                                appointmentObservable
                                            .afternoonDateTimeRanges.length >=
                                        1
                                    ? Consumer<AppointmentObservable>(
                                        builder: (context, data, _) {
                                        return GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: data
                                              .afternoonDateTimeRanges.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio:
                                                      (itemWidth / itemHeight),
                                                  crossAxisCount:
                                                      (screenSizeWidth /
                                                              itemWidth)
                                                          .ceil()
                                                          .toInt(),
                                                  crossAxisSpacing: 8,
                                                  mainAxisSpacing: 8),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buttonTimeWidget(
                                                data.afternoonDateTimeRanges[
                                                    index]);
                                          },
                                        );
                                      })
                                    : Text(
                                        "No hay citas disponibles",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                SizedBox(height: 32),
                                Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextButton(
                                      onPressed: () {
                                        Provider.of<AppointmentObservable>(
                                                context,
                                                listen: false)
                                            .book();
                                      },
                                      child: Text(
                                        "Reservar",
                                        style: CustomTextStyles()
                                            .onboardingBtnTextStyle(context),
                                      ),
                                      style: TextButton.styleFrom(
                                          shape: (RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          )),
                                          padding: EdgeInsets.fromLTRB(
                                              16, 16, 16, 16),
                                          backgroundColor:
                                              ConstantColors.mainColorApp),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Provider.of<AppointmentObservable>(
                                                  context,
                                                  listen: false)
                                              .showErrMessage
                                          ? Provider.of<AppointmentObservable>(
                                                  context,
                                                  listen: false)
                                              .errMessage
                                          : "",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.withOpacity(0.7)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }

  //buttonTime
  Widget _buttonTimeWidget(DateTimeRange timeRange) {
    return Consumer<AppointmentObservable>(builder: (context, data, _) {
      return Container(
        decoration: BoxDecoration(
            color: Provider.of<AppointmentObservable>(context, listen: false)
                        .selectedTimeRange ==
                    timeRange
                ? ConstantColors.mainColorApp
                : ConstantColors.myWhite,
            border: Border.all(
                color: ConstantColors.myBlack,
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12)),
        child: TextButton(
            onPressed: () {
              data.selectedTimeRange = timeRange;
            },
            child: Text(timeRange.toHourString(),
                maxLines: 1,
                style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.foregroundTxtButtonColor,
                    fontSize: 14))),
      );
    });
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

    bool _isDateColumnPicked(int selectedDay) {
      return this.dateTime.day == selectedDay;
    }

    return Selector<AppointmentObservable, bool>(
        selector: (_, provider) => provider.isDayAvailable(dateTime),
        builder: (context, isDayAvailable, child) {
          return InkWell(
              onTap: () {
                if (appointmentObservable.isDayAvailable(this.dateTime)) {
                  appointmentObservable.selectedDate = dateTime;
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (appointmentObservable.isDayAvailable(this.dateTime))
                        ? Theme.of(context).colorScheme.foregroundPlainTxtColor
                        : Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _isDateColumnPicked(
                          appointmentObservable.selectedDate.day)
                      ? ConstantColors.mainColorApp
                      : ConstantColors.myWhite,
                ),
                child: Column(
                  children: <Widget>[
                    Text(appointmentObservable.dayName(dateTime),
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .foregroundPlainTxtColor)),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: Text(dateTime.day.toString(),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .foregroundPlainTxtColor))),
                  ],
                ),
              ));
        });
  }
}
