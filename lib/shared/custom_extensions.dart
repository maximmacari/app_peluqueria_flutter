import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BoolExtension on bool {
  bool toggle() => !this;
}

extension StringExtension on String {
  String capitalized() => "${this[0].toUpperCase()}${this.substring(1)}";
}

extension DateTimeExtension on DateTime {
  bool get isSaturday => this.weekday == 6;
  bool get isSunday => this.weekday == 7;
  bool get isAfternoon => this.isAfter(DateTime(this.year, this.month, this.day, 14));
  bool get isMorning => this.isBefore(DateTime(this.year, this.month, this.day, this.isSaturday ? 15 : 14));
  int get timestamp => this.millisecondsSinceEpoch;
}

extension DateTimeRangeExt on List<DateTimeRange> {
  //removes DTRanges that match in any sens.
  List<DateTimeRange> removeCollidingTimeRanges(
      List<DateTimeRange> timeRanges) {
    timeRanges
        .map((timeRange) =>
            this.removeWhere((range) => range.collidesWith(timeRange)))
        .toList();
    return this;
  }
}

extension DateTimeRangeExte on DateTimeRange {
  bool collidesWith(DateTimeRange dateTimeRange) {
    //return true if this.start or this.end is in betwwen dateTimeRange.start or dateTimeRange.end
    //Avoids DateTimes that matchs exactly
    if (this.start.isAfter(dateTimeRange.start) &&
        this.start.isBefore(dateTimeRange.end)) {
      return true;
    } else if (this.end.isAfter(dateTimeRange.start) &&
        this.end.isBefore(dateTimeRange.end)) {
      return true;
    }
    return false;
  }

  String toHourString(){
    var formatter = DateFormat.Hm();     
    return "${formatter.format(this.start)} - ${formatter.format(this.end)}";
  }
}
