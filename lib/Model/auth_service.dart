import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Shared/alert_dialog.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  static AuthService _authService;
  String _verificationId = "";

  static AuthService of(context) {
    if (_authService == null)
      _authService = AuthService(context);
    else
      _authService.context = context;
    return _authService;
  }

  BuildContext context;
  AuthService(this.context);

  void sendCode(String smsCode, bool showLoading) {
    try {
      print("code: $smsCode");
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);
      _signinWithPhoneAuthCredential(phoneAuthCredential, showLoading);
    } catch (err) {
      OkAlertDialog("Error", "Ha habido un error: ${err.toString()}",
          () => Navigator.of(context).pop("ok"));
    }
  }

  void verifyPhone(
      String phoneNumberNoPrefix, String smsCode, bool showLoading) async {
    final String phoneNumberE164 = "+34" + phoneNumberNoPrefix;
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberE164,
        //autoRetrievedSmsCodeForTesting: "+34645962530", // only testing
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          showLoading = false;
          print("Phoneverification completed.");

          //no lo utilizo
          _signinWithPhoneAuthCredential(phoneAuthCredential, showLoading);
        },
        verificationFailed: (FirebaseAuthException fbException) async {
          showLoading = false;

          print("err: ${fbException.message}");
          OkAlertDialog("Error", "${fbException.message}",
              () => {Navigator.of(context).pop("ok")});
          print("Phoneverification failed.");
        },
        codeSent: (String verificationId, int resendingToken) async {
          showLoading = false;
          _verificationId = verificationId;
          print("verificationId: $_verificationId");
        },
        //after the time out..60 seconds this method is called
        codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) async {
          showLoading = false;
          _verificationId = codeAutoRetrievalTimeout;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("OTP error: se acabó el tiempo"),
          ));
          print("err: ${codeAutoRetrievalTimeout}");
        });
  }

  void _signinWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential, bool showLoading) async {
    showLoading = true;

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
      showLoading = false;
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
