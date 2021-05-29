import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/Model/salon_service.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases, pero pudinedo utilizar sus propiedades.
class AppointmentObservable with ChangeNotifier {

  SalonService _selectedService = SalonService(duration: '', subgroup: '', name: '', price: '', id: '');
  DateTime _selectedDay = DateTime.now(); // 13/05/2021
  DateTime _selectedTime = DateTime.now();
  
  DateTime _createdDate = DateTime.now();
  
  DateTime get selectedTime => _selectedTime;

  set selectedTimeAdd(Duration newTime) {
    this._selectedTime = selectedTime.add(newTime) ;
  }

  //var endTime = selectedTimeAdd((const Duration(days: 60)));

}
