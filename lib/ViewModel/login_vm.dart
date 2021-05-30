import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_auth1/shared/custom_extensions.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases.
class LoginObservable with ChangeNotifier {
  
  bool _termsAccepted = false;
  bool _buttonEnabled = true;
  final int _secsButtonAvailable = 60;
  String _verificationId = "";
  bool _showLoading = false;

  bool get termsAccepted => _termsAccepted;
  bool get buttonEnabled => _buttonEnabled;
  String get verificationId => _verificationId;
  bool get showLoading => _showLoading;

  set termsAccepted(bool accepted) {
    _termsAccepted = accepted;
    notifyListeners();
  }

  set buttonEnabled(bool enabled) {
    _buttonEnabled = buttonEnabled;
    notifyListeners();
  }

  set verificationId(String verificationId){
    _verificationId = verificationId;
    notifyListeners();
  }

  void showLoadingToggle(){
    _showLoading.toggle;
  }



  

}
