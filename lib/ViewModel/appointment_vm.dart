import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter_sms_auth1/shared/custom_extensions.dart";
import 'package:intl/intl.dart';
import 'dart:io';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class AppointmentObservable with ChangeNotifier {
  String _selectedServiceName = "corte caballero";
  DateFormat _dateFormat = DateFormat.yMd(Platform.localeName.toString());
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  DateTime _createdDate = DateTime.now();
  DateTime get selectedTime => _selectedTime;

  set selectedTimeAdd(Duration newTime) {
    this._selectedTime = selectedTime.add(newTime);
    notifyListeners();
  }

  set selectedServiceName(String newServiceName) {
    this._selectedServiceName = newServiceName;
    notifyListeners();
  }

  set selectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;
    notifyListeners();
    print("_selectedDate: $_selectedDate");
  }

  void nextMonth() {
    if (isDateAccesibleForward) {
      selectedDate = new DateTime(_selectedDate.year, _selectedDate.month + 1);
    }
  }

  void previousMonth() {
    if (isDateAccesibleBackward) {
      selectedDate = new DateTime(_selectedDate.year, _selectedDate.month - 1);
    }
  }

  DateTime get twoMonthsForward =>
      DateTime(DateTime.now().year, DateTime.now().month + 2);
  bool get isDateAccesibleForward => _selectedDate.isBefore(twoMonthsForward);
  bool get isDateAccesibleBackward =>
      _selectedDate.month > DateTime.now().month;
  String get selectedServiceName => _selectedServiceName;
  String get currentLocale => Platform.localeName.toString();
  DateTime get selectedDate => _selectedDate;
  DateFormat get dateFormat => _dateFormat;
  DateTime get yesterday => DateTime.now().subtract(Duration(days: 1));
  String montAndYear() {
    final int montNumber = _selectedDate.month;
    return """
    ${DateFormat.LLLL("es_ES").dateSymbols.MONTHS[montNumber - 1].toString().capitalized()}, ${selectedDate.year}""";
  }

  //var endTime = selectedTimeAdd((const Duration(days: 60)));

  List<DateTime> daysInMonth() {
    int totalMonthDays = _daysInMonth(_selectedDate.month, _selectedDate.year);
    print("Totalmonthdays: $totalMonthDays");
    var listDateTimes = new List<DateTime>.generate(totalMonthDays,
        (i) => DateTime(DateTime.now().year, DateTime.now().month, i + 1));
    listDateTimes.removeWhere((element) => element.isBefore(yesterday));
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
      31  // december
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
