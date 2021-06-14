import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_auth1/Model/appointment.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import "package:flutter_sms_auth1/Shared/custom_extensions.dart";
import 'package:intl/intl.dart';
import 'dart:io';

//TODO
// push appointmentto firebase
// get user appointments  read if user.UID == User.id
// Listview of the user.appointments
// guardar el fichero en almacenamiento interno
// validate json https://medium.com/codechai/validating-json-in-flutter-6f07ec9344f8
// json file validation https://stackoverflow.com/questions/52240607/how-to-check-if-a-file-was-edited-modified-by-a-user
// Listview images for superuser
// Screen for superuser, manage the appointments
// missing firebaseOAuth.loggout
//onboarding button dosnt work
//firestore flutter docs https://firebase.flutter.dev/docs/firestore/usage#adding-documents
//push name rute form home to setappoitnment, slow

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class AppointmentObservable with ChangeNotifier {
  SalonService _selectedSalonService = SalonService(
      Codigo: "230",
      Subgrupo: "tintes",
      Nombre: "Sin seleccionar",
      Duracion: "25",
      Precio: "15.90 ");
  String _auxSubgroup = "";
  DateFormat _dateFormat = DateFormat.yMd(Platform.localeName.toString());
  DateTime _selectedDate = DateTime.now();
  DateTimeRange _selectedTimeRange;
  List<DateTime> _holidays = [];
  List<DateTimeRange> _afternoonDateTimeRanges = [];
  List<DateTimeRange> _morningDateTimeRanges = [];
  List<Appointment> _foreignBookedAppointments = [];
  final _authFirebase = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTimeRange _dateTimeRangeSelected;
  String _errMessage = "";
  bool _showErrMessage = false;
  bool get showErrMessage => _showErrMessage;
  bool get isDateAccesibleForward => _selectedDate.isBefore(twoMonthsForward);
  bool get isDateAccesibleBackward =>
      _selectedDate.month > DateTime.now().month;
  SalonService get selectedSalonService => _selectedSalonService;
  String get auxSubgroup => _auxSubgroup;
  String get currentLocale => Platform.localeName.toString();
  String get errMessage => _errMessage;
  DateTimeRange get selectedTimeRange => _selectedTimeRange;
  DateTime get twoMonthsForward =>
      DateTime(DateTime.now().year, DateTime.now().month + 2);
  DateTime get selectedDate => _selectedDate;
  DateFormat get dateFormat => _dateFormat;
  DateTime get yesterday => DateTime.now().subtract(Duration(days: 1));
  DateTimeRange get dateTimeRange => _dateTimeRangeSelected;
  List<DateTimeRange> get morningDateTimeRanges => _morningDateTimeRanges;
  List<DateTimeRange> get afternoonDateTimeRanges => _afternoonDateTimeRanges;

  set dateTimeRangeSelected(DateTimeRange newDateTimeRange) {
    this._dateTimeRangeSelected = newDateTimeRange;
    notifyListeners();
  }

  set errMessage(String newMsg) {
    _errMessage = newMsg;
  }

  set auxSubgroup(String newValue) {
    _auxSubgroup = newValue;
  }

  set selectedTimeRange(DateTimeRange newTimeRange) {
    _selectedTimeRange = newTimeRange;
    _showErrMessage = false;
    notifyListeners();
    print("Selected Time range: ${_selectedTimeRange.toHourString()}");
  }

  set selectedService(SalonService newSalonService) {
    this._selectedSalonService = newSalonService;
    getMoriningRangeTimes();
    getAfternoonRangeTimes();
    _showErrMessage = false;
    notifyListeners();
    print("Appointment, _seletedSalonService: $_selectedSalonService");
  }

  set selectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;
    notifyListeners();
    print("_selectedDate: $_selectedDate");
  }

  void nextMonth() {
    if (isDateAccesibleForward) {
      if (_selectedDate.month == 12) {
        _selectedDate = new DateTime(_selectedDate.year + 1, 1);
        getMoriningRangeTimes();
        getAfternoonRangeTimes();
        notifyListeners();
      } else {
        _selectedDate =
            new DateTime(_selectedDate.year, _selectedDate.month + 1);
        getMoriningRangeTimes();
        getAfternoonRangeTimes();
        notifyListeners();
      }
    }
  }

  bool isDayAvailable(DateTime dateTime) {
    if (dateTime.isSunday || _holidays.contains(dateTime)) {
      return false;
    }
    return true;
  }

  void previousMonth() {
    if (isDateAccesibleBackward) {
      if (_selectedDate.month == 1) {
        selectedDate = new DateTime(_selectedDate.year - 1, 12);
        getMoriningRangeTimes();
        getAfternoonRangeTimes();
        notifyListeners();
      } else {
        selectedDate =
            new DateTime(_selectedDate.year, _selectedDate.month - 1);
        getMoriningRangeTimes();
        getAfternoonRangeTimes();
        notifyListeners();
      }
    }
  }

  void getForeignReservations() async {
    await firestore.collection("RESERVATIONS").get().then((querySnapshot) {
      querySnapshot.docs.forEach((reservation) async {
          await firestore.doc(reservation.id.toString()).collection("public").get();
          https://mullr.dev/2020/07/05/handling-nested-objects-in-firestore-with-flutter/
          /* .then((publicData) => {
            publicData.docs.forEach((element) {
              print("public stattime ${element.id}");
            })
          } */
          //);
          /* firestore.doc(reservation.id.toString()).collection("private").get().then((privateData) => {
            privateData.docs.forEach((element) {
              print("private ${element["phoneNumber"]}");
            })
          }); */

      
      
        //_appointmentsList.add(Appointment.fromJson(result.data()));
        
        //print("result ${reservation.id}");
        //print("public ${reservation.}");
      });
    });
  }

  List<DateTimeRange> generateWorkingDayDateTimeRanges() {
    /**
     * Schedule of the store
     *  Monday - Friday 9:30 - 19:30 ; breaks 14:00 - 16:00
     *  Saturday 9:00 - 15:00
     */
    final int _openingHour = 9;
    final int _openingMinutes = _selectedDate.isSaturday ? 0 : 30;
    final int _closeHour = _selectedDate.isSaturday ? 15 : 19;
    final int _closeMinutes = _selectedDate.isSaturday ? 0 : 30;
    final int _hourStartBreak = 14;
    final int _hourEndBreak = 16;
    DateTime _opening = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _openingHour, _openingMinutes);
    DateTime _close = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _closeHour, _closeMinutes);
    DateTime _startBreak = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _hourStartBreak);
    DateTime _endBreak = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _hourEndBreak);
    DateTimeRange _brakeRangeTime =
        DateTimeRange(start: _startBreak, end: _endBreak);
    DateTimeRange _saturdayAfternoonRangeTimes = DateTimeRange(
        start: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day, 15),
        end: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day, 19));

    DateTimeRange _workingDay = DateTimeRange(start: _opening, end: _close);
    //return [];
    final List<DateTimeRange> timeRanges = generateDateTimeRanges(_workingDay);
    if (_selectedDate.isSaturday)
      timeRanges.removeCollidingTimeRanges([_saturdayAfternoonRangeTimes]);
    return timeRanges.removeCollidingTimeRanges(
      [
        _brakeRangeTime,
      ],
    ); //substract Firestore ones from this
  }

  void getMoriningRangeTimes() {
    _morningDateTimeRanges = generateWorkingDayDateTimeRanges();
    _morningDateTimeRanges.retainWhere((element) => element.end.isMorning);
  }

  void getAfternoonRangeTimes() {
    _afternoonDateTimeRanges = generateWorkingDayDateTimeRanges();
    _afternoonDateTimeRanges.retainWhere((element) => element.end.isAfternoon);
  }

  void book() async {
    //check timerange is in day selected
    if (_selectedTimeRange == null) {
      _errMessage = "Debes seleccionar un hora.";
      _showErrMessage = true;
      return;
    }

    if (_selectedSalonService.name == "Sin seleccionar") {
      _errMessage = "Debes seleccionar un servicio.";
      _showErrMessage = true;
      return;
    }

    if (_selectedTimeRange.start.isAfter(selectedDate)) {
      final Appointment appointment = Appointment(
          endTime: selectedTimeRange.end.timestamp.toString(),
          startTime: selectedTimeRange.start.timestamp.toString(),
          serviceId: _selectedSalonService.id,
          creationTime: DateTime.now().timestamp.toString());

      addReservationToFirestore(appointment);
    }
  }

  void addReservationToFirestore(Appointment appointment) async {
    CollectionReference reservationsColl = firestore.collection('RESERVATIONS');
    await reservationsColl.add({}).then((reservation) => {
          print(" - Reservation id created: ${reservation.id}"),
          reservationsColl
              .doc(reservation.id)
              .collection("public")
              .add(appointment.toJson())
              .then((publicDoc) => {
                    print("public id: ${publicDoc.id}"),
                    print("${appointment.toJson()}")
                  }),
          reservationsColl
              .doc(reservation.id)
              .collection("private")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .set({
            "phoneNumber": FirebaseAuth.instance.currentUser.phoneNumber
          })
        });
  }

  List<DateTimeRange> generateDateTimeRanges(DateTimeRange dayRange) {
    List<DateTimeRange> timeRanges = [];
    DateTime _auxStart = dayRange.start;
    DateTime _auxEnd = dayRange.start;

    while (_auxEnd.isBefore(dayRange.end)) {
      _auxEnd = _auxEnd
          .add(Duration(minutes: int.parse(_selectedSalonService.duration)));
      timeRanges.add(new DateTimeRange(start: _auxStart, end: _auxEnd));
      _auxStart = _auxEnd;
    }
    return timeRanges;
  }

  String monthAndYear() {
    final int montNumber = _selectedDate.month;
    return """
    ${DateFormat.LLLL("es_ES").dateSymbols.MONTHS[montNumber - 1].toString().capitalized()}, ${selectedDate.year}""";
  }

  List<DateTime> daysInMonth() {
    int totalMonthDays = _daysInMonth(_selectedDate.month, _selectedDate.year);
    print("Totalmonthdays: $totalMonthDays");
    var listDateTimes = new List<DateTime>.generate(totalMonthDays,
        (i) => DateTime(DateTime.now().year, _selectedDate.month, i + 1));
    listDateTimes.retainWhere((element) => element.isAfter(yesterday));
    return listDateTimes;
  }

  String dayName(DateTime date) {
    final List<String> weekDaysAbbreviations = [
      "LU",
      "MA",
      "MI",
      "JU",
      "VI",
      "SA",
      "DO"
    ];
    return weekDaysAbbreviations[date.weekday - 1];
  }

  int _daysInMonth(final int monthNum, final int year) {
    List<int> monthLength = [
      31, // january
      _leapYear(year) ? 29 : 28, // february
      31, // march
      30, // april
      31, // may
      30, // june
      31, // july
      31, // august
      30, // September
      31, // octomber
      30, // november
      31 // december
    ];
    return monthLength[monthNum - 1];
  }

  bool _leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }
}
