import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_auth1/Model/auth_service.dart';
import 'package:flutter_sms_auth1/Shared/custom_extensions.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases.
class LoginObservable with ChangeNotifier {
  final RegExp PHONE_REGEX = RegExp("(6|7)[ -]*([0-9][ -]*){8}");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Timer _timer;
  bool _termsAccepted = false;
  bool _buttonEnabled = true;
  int _secsButtonAvailable = 60;
  bool _showLoading = false;

  TextEditingController get phoneController => _phoneController;
  TextEditingController get codeController => _codeController;
  
  Timer get timer => _timer;
  bool get termsAccepted => _termsAccepted;
  bool get buttonEnabled => _buttonEnabled;
  bool get showLoading => _showLoading;
  int get secsButtonAvailable => _secsButtonAvailable;
  AuthService authService;

  void initAuthService(context){
    authService = AuthService(context);
    
  }

  set termsAccepted(bool accepted) {
    _termsAccepted = accepted;
    notifyListeners();
  }

  set secsButtonAvailable(int seconds) {
    _secsButtonAvailable = 60;
    notifyListeners();
  }

  set buttonEnabled(bool enabled) {
    _buttonEnabled = buttonEnabled;
    notifyListeners();
  }

  void receiveSMS(context) {
    if (_buttonEnabled) {
        _showLoading = true;
        authService.verifyPhone(_phoneController.text, _codeController.text, _showLoading);
        this._buttonEnabled.toggle();
        startTimer();
    }
  }

  void sendCodeOTP(){
    //authService.sendCode(_codeController.text, _showLoading);
  }

  void startTimer() {
    const _oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      _oneSec,
      (Timer timer) {
        if (_secsButtonAvailable == 0) {
          _timer.cancel();
          _secsButtonAvailable = 60;
          this._buttonEnabled.toggle();
        } else {
          _secsButtonAvailable--;
          print("sec: $_secsButtonAvailable");
        }
      },
    );
  }


}
