import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_auth1/Model/appointment.dart';
import 'package:flutter_sms_auth1/Model/salon_service.dart';
import "package:flutter_sms_auth1/Shared/custom_extensions.dart";
import 'package:intl/intl.dart';
import 'dart:io';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class AppointmentObservable with ChangeNotifier {
  SalonService _selectedSalonService = SalonService(
      duration: '15',
      name: 'caballero',
      subgroup: 'cortes',
      price: '9.50',
      id: '210'); //TODO cahnge name
  DateFormat _dateFormat = DateFormat.yMd(Platform.localeName.toString());
  DateTime _selectedDate = DateTime.now();
  DateTimeRange _selectedTimeRange;
  List<DateTime> _holidays = [];

  DateTimeRange _dateTimeRangeSelected;

  set dateTimeRangeSelected(DateTimeRange newDateTimeRange) {
    this._dateTimeRangeSelected = newDateTimeRange;
    notifyListeners();
  }

  set selectedTimeRange(DateTimeRange newTimeRange) {
    _selectedTimeRange = newTimeRange;
    notifyListeners();
  }

  set selectedServiceName(SalonService newSalonService) {
    this._selectedSalonService = newSalonService;
    notifyListeners();
  }

  set selectedDate(DateTime newDateTime) {
    _selectedDate = newDateTime;
    notifyListeners();
    print("_selectedDate: $_selectedDate");
  }

  void nextMonth() {
    if (isDateAccesibleForward) {
      if (_selectedDate.month == 12) {
        selectedDate = new DateTime(_selectedDate.year + 1, 1);
      } else {
        selectedDate =
            new DateTime(_selectedDate.year, _selectedDate.month + 1);
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
      } else {
        selectedDate =
            new DateTime(_selectedDate.year, _selectedDate.month - 1);
      }
    }
  }

  List<DateTimeRange> presentDateTimeRanges() {
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

    DateTimeRange _workingDay = DateTimeRange(start: _opening, end: _close);
    //return [];
    final List<DateTimeRange> timeRanges = generateDateTimeRanges(_workingDay);
    return timeRanges.removeCollidingTimeRanges(
        [_brakeRangeTime]); //substract Firestore ones from this
  }

  List<DateTimeRange> getMoriningRangeTimes(){
    var moringTimeRanges = presentDateTimeRanges();
    moringTimeRanges.retainWhere((element) => element.end.isMorning);
    return moringTimeRanges;
  }

  List<DateTimeRange> getAfternoonRangeTimes(){
    var afternoonTimeRanges = presentDateTimeRanges();
    afternoonTimeRanges.retainWhere((element) => element.end.isAfternoon);
    return afternoonTimeRanges;
  }

  void reservar(){
    if (_selectedTimeRange != null ) { //user.uuid != null
      //Firebase push Appiintment
      final Appointment appointment = Appointment(endTimestamp: selectedTimeRange.end.timestamp.toString(),
      idStartTimestamp: selectedTimeRange.start.timestamp.toString(),
      serviceId: _selectedSalonService.id,
      timestampCreation: DateTime.now().timestamp.toString(),
      userUID: ); // Aqui
    }
  }



  List<DateTimeRange> generateDateTimeRanges(DateTimeRange dayRange) {
    //makes DateTimeRanges for specific salonService
    List<DateTimeRange> timeRanges = [];

    DateTime _auxStart = dayRange.start;
    DateTime _auxEnd = dayRange.start;

    
    while (_auxEnd.isBefore(dayRange.end)) {
      
      _auxEnd = _auxEnd.add(Duration(minutes: int.parse(_selectedSalonService.duration)));
      timeRanges.add(new DateTimeRange(start: _auxStart, end: _auxEnd));
      _auxStart = _auxEnd;
      //print("range created: ${DateTimeRange(end: _auxEnd, start: _auxStart)}");
    } 
    return timeRanges;
  }

  bool get isDateAccesibleForward => _selectedDate.isBefore(twoMonthsForward);
  bool get isDateAccesibleBackward =>
      _selectedDate.month > DateTime.now().month;
  SalonService get selectedSalonService => _selectedSalonService;
  String get currentLocale => Platform.localeName.toString();
  DateTimeRange get selectedTimeRange => _selectedTimeRange;
  DateTime get twoMonthsForward =>
      DateTime(DateTime.now().year, DateTime.now().month + 2);
  DateTime get selectedDate => _selectedDate;
  DateFormat get dateFormat => _dateFormat;
  DateTime get yesterday => DateTime.now().subtract(Duration(days: 1));
  DateTimeRange get dateTimeRange => _dateTimeRangeSelected;

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
