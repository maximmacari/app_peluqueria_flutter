import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_sms_auth1/Model/salon_service.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class AppointmentObservable with ChangeNotifier {
  SalonService _selectedService =
      SalonService(duration: '', subgroup: '', name: '', price: '', id: '');
  DateFormat _dateFormat = DateFormat.yMd(Platform.localeName.toString());
  DateTime _selectedDate = DateTime.now(); // 13/05/2021
  DateTime _selectedTime = DateTime.now();
  DateTime _createdDate = DateTime.now();
  DateTime get selectedTime => _selectedTime;

  set selectedTimeAdd(Duration newTime) {
    this._selectedTime = selectedTime.add(newTime);
  }

  set selectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;
    notifyListeners();
  }

  String get currentLocale => Platform.localeName.toString();
  DateTime get selectedDate => _selectedDate;
  DateFormat get dateFormat => _dateFormat;
  DateTime get yesterday => DateTime.now().subtract(Duration(days: 1));

  //var endTime = selectedTimeAdd((const Duration(days: 60)));

  List<DateTime> daysInMonth() {
    var firstDayThisMonth = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    int totalMontDays = firstDayNextMonth.difference(firstDayThisMonth).inDays;
    var listDateTimes = new List<DateTime>.generate(totalMontDays,
        (i) => DateTime(DateTime.now().year, DateTime.now().month, i + 1));
    listDateTimes.removeWhere((element) => element.isBefore(DateTime.now()));
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
}
