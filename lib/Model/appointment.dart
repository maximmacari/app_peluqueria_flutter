import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  ///  FIREBASE JSON
  ///
  ///  - DateTime appointmentTimestamp
  ///    - ServiceID => allow read if userUid == userUID
  ///    - UserUid => allow read if userUid == userUID
  ///    - DateTime creationDateTime
  ///    - DateTime endAppointmentTimestamp

  final Timestamp creationTime;
  final Timestamp startTime;
  final Timestamp endTime;
  final String serviceId;
  String phoneNumber;

  set setPhoneNumber(String newPhoneNumber) {
    this.phoneNumber = newPhoneNumber;
  }

//https://stackoverflow.com/questions/52993123/firestore-security-rules-allow-user-to-create-doc-only-if-new-doc-id-is-same-as
  Appointment(
      {@required this.startTime,
      @required this.serviceId,
      @required this.creationTime,
      @required this.endTime,
      this.phoneNumber});

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
            startTime: json['startTime'] as Timestamp,
            serviceId: json['serviceId'] as String,
            creationTime: json['creationTime'] as Timestamp,
            endTime: json['endTime'] as Timestamp);

  Map<String, dynamic> toJson() {
    return {
      'creationTime': creationTime,
      'endTime': endTime,
      'serviceId': serviceId,
      'startTime': startTime
    };
  }

  @override
    String toString() {
      // TODO: implement toString
      return """
        $startTime, $endTime, $serviceId, $creationTime, $phoneNumber
      """;
    }
}

//https://stackoverflow.com/questions/62517014/google-firestore-delete-all-collections-older-than-x-hours
