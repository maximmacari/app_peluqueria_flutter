import 'package:flutter/material.dart';

class Appointment {
  ///  FIREBASE JSON
  ///
  ///  - DateTime appointmentTimestamp
  ///    - ServiceID => allow read if userUid == userUID
  ///    - UserUid => allow read if userUid == userUID
  ///    - DateTime creationDateTime
  ///    - DateTime endAppointmentTimestamp

  final String creationTime;
  final String startTime;
  final String endTime;
  final String serviceId;
  final String phoneNumber;
  


//https://stackoverflow.com/questions/52993123/firestore-security-rules-allow-user-to-create-doc-only-if-new-doc-id-is-same-as
  Appointment(
      {@required this.startTime,
      @required this.serviceId,
      @required this.creationTime,
      @required this.endTime,
      this.phoneNumber});

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
            startTime: json['startTime'] as String,
            serviceId: json['serviceId'] as String,
            creationTime: json['creationTime'] as String,
            endTime: json['endTime'] as String);

  Map<String, dynamic> toJson() {
    return {
      'creationTime': creationTime,
      'endTime': endTime,
      'serviceId': serviceId,
      'startTime': startTime
    };
  }
}

//https://stackoverflow.com/questions/62517014/google-firestore-delete-all-collections-older-than-x-hours
