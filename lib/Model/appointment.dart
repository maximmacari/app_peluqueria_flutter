import 'package:flutter/material.dart';

class Appointment {
  ///  FIREBASE JSON
  ///
  ///  - DateTime appointmentTimestamp
  ///    - ServiceID => allow read if userUid == userUID
  ///    - UserUid => allow read if userUid == userUID
  ///    - DateTime creationDateTime
  ///    - DateTime endAppointmentTimestamp

  final String idStartTimestamp;
  final String serviceId;
  final String userUID;
  final String timestampCreation;
  final String endTimestamp;

  Appointment(
      {@required this.idStartTimestamp,
      @required this.serviceId,
      @required this.userUID,
      @required this.timestampCreation,
      @required this.endTimestamp});

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
            idStartTimestamp: json['idStartTimestamp'] as String,
            serviceId: json['serviceId'] as String,
            userUID: json['userUID'] as String,
            timestampCreation: json['timestampCreation'] as String,
            endTimestamp: json['endTimestamp'] as String);

  Map<String, dynamic> toJson() {
    return {
      'idStartTimestamp': idStartTimestamp,
      'serviceId': serviceId,
      'userUID': userUID,
      'timestampCreation': timestampCreation,
      'endTimestamp': endTimestamp
    };
  }
}

//https://stackoverflow.com/questions/62517014/google-firestore-delete-all-collections-older-than-x-hours
