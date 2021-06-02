import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Shared/alert_dialog.dart';
import 'package:flutter_sms_auth1/ViewModel/login_vm.dart';
import 'package:provider/provider.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  static AuthService _authService;
  bool _showLoading = false;
  String _verificationId = "";

  bool get showLoading => _showLoading;

  set showLoading(bool newValue) {
    _showLoading = newValue;
  }

  static AuthService of(context) {
    if (_authService == null)
      _authService = AuthService(context);
    else
      _authService.context = context;
    return _authService;
  }

  BuildContext context;
  AuthService(this.context);

  void sendCode(String smsCode) {
    try {
      print("code: $smsCode");
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);
      _signinWithPhoneAuthCredential(phoneAuthCredential);
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => Navigator.of(context).pop("ok"));
    }
  }

  void verifyPhone(String phoneNumberNoPrefix, String smsCode) async {
    final String phoneNumberE164 = "+34" + phoneNumberNoPrefix;
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberE164,
        //autoRetrievedSmsCodeForTesting: "+34645962530", // only testing
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          print("Phoneverification completed.");
          //no lo utilizo
          _signinWithPhoneAuthCredential(phoneAuthCredential);
          _showLoading = false;
        },
        verificationFailed: (FirebaseAuthException fbException) async {
          print("err: ${fbException.message}");
          OkAlertDialog("Error", "${fbException.message}",
              () => {Navigator.of(context).pop("ok")});
          print("Phoneverification failed.");
          _showLoading = false;
        },
        codeSent: (String verificationId, int resendingToken) async {
          _verificationId = verificationId;
          print("verificationId: $_verificationId");
          _showLoading = false;
        },
        //after the time out..60 seconds this method is called
        codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) async {
          _verificationId = codeAutoRetrievalTimeout;
          if (auth.currentUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("OTP error: se acabó el tiempo"),
            ));
          }
          print("err: ${codeAutoRetrievalTimeout}");
          _showLoading = false;
        });
  }

  void _signinWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential) async {
    _showLoading = true;
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        print("Ha entrado: ${authCredential.user}");
        Navigator.of(context).pushNamed(Screen.HOME);
      }
    } on FirebaseAuthException catch (e) {
      OkAlertDialog(
          "Error", e.message, () => {Navigator.of(context).pop("ok")});
    } finally {
      _showLoading = false;
    }
  }

  void signOut() async {
    try {
      if (auth.currentUser != null) {
        await auth.signOut();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Screen.LOGIN, (route) => false);
      }
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => {Navigator.of(context).pop()});
    }
  }
}
