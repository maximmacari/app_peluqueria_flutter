import 'package:flutter/material.dart';

class Appointment {
  DateTime idStartTimestamp;
  String serviceName;
  String userUID;
  DateTime timestampCreation;
  DateTime endTimestamp;

  Appointment(
      {@required this.idStartTimestamp,
      @required this.serviceName,
      @required this.userUID,
      @required this.timestampCreation,
      @required this.endTimestamp});
}

//https://stackoverflow.com/questions/62517014/google-firestore-delete-all-collections-older-than-x-hours