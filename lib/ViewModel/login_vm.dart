import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sms_auth1/Model/auth_service.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases.
class LoginObservable with ChangeNotifier {
  final RegExp PHONE_REGEX = RegExp("(6|7)[ -]*([0-9][ -]*){8}");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Timer _timer;
  bool _termsAccepted = false;
  bool _buttonEnabled = true;
  int _secsButtonAvailable = 60;

  TextEditingController get phoneController => _phoneController;
  TextEditingController get codeController => _codeController;
  Timer get timer => _timer;
  bool get termsAccepted => _termsAccepted;
  bool get buttonEnabled => _buttonEnabled;
  
  int get secsButtonAvailable => _secsButtonAvailable;
  AuthService authService;

  void initAuthService(context){
    authService = AuthService(context);
  }

  set termsAccepted(bool accepted) {
    _termsAccepted = accepted;
    notifyListeners();
  }
  

  set buttonEnabled(bool newValue){
    _buttonEnabled = newValue;
    notifyListeners();
  }

  set secsButtonAvailable(int seconds) {
    _secsButtonAvailable = 60;
    notifyListeners();
  }

  void receiveSMS(context) {
    if (_buttonEnabled) {
        authService.showLoading = true;
        authService.verifyPhone(_phoneController.text, _codeController.text,);
        print("principio buttonenabled: ${_buttonEnabled}");
        buttonEnabled = !_buttonEnabled;
        print("buttonenabled: ${_buttonEnabled}");
        startTimer();
    }
  }

  void sendCodeOTP(){
    authService.sendCode(_codeController.text);
  }

  void startTimer() {
    const _oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(_oneSec,(Timer timer) {
        notifyListeners();
        if (secsButtonAvailable == 0) {
          _timer.cancel();
          _secsButtonAvailable = 60;
          buttonEnabled = !_buttonEnabled;
          notifyListeners();
        } else {
          _secsButtonAvailable--;
          print("sec: $secsButtonAvailable");
          notifyListeners();
        }
        notifyListeners();
      },
      
    );
    notifyListeners();
    
  }


}
