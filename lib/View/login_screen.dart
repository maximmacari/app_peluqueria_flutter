import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/shared/alert_dialog.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PHONE_REGEX = RegExp("(6|7)[ -]*([0-9][ -]*){8}");

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusPhoneField = new FocusNode();
  final _phoneFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  bool conditionAccepted = false;

  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusCodeField = new FocusNode();

  Timer _timer;
  bool _buttonEnabled = true;
  int _secsButtonAvailable = 60;

  //Firebase auth
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String verificationId = "";
  bool showLoading = false;

  void _buttonToggleAvilability() {
    setState(() {
      if (_buttonEnabled)
        _buttonEnabled = false;
      else
        _buttonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
          child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 2),
              Text("Introduce tu numero"),
              Form(
                key: _phoneFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    new CustomInputFormatter(),
                    LengthLimitingTextInputFormatter(
                        11) //phone number(9) + separation every 3 chars (2)
                  ],
                  focusNode: _focusPhoneField,
                  autofocus: false,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 24),
                  decoration: InputDecoration(
                      suffix: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              receiveSMS();
                            },
                            child: Text(
                              _buttonEnabled
                                  ? "Recibir SMS"
                                  : "$_secsButtonAvailable sec SMS",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: TextButton.styleFrom(
                                shape: (RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                                padding: EdgeInsets.all(12),
                                primary: Colors.black,
                                backgroundColor:
                                    _buttonEnabled ? Colors.blue : Colors.grey),
                          ),
                        ],
                      ),
                      hintText: "645 962 530", // Use company number
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                      prefixIcon: Icon(
                        Icons.mobile_friendly,
                        color: Colors.black,
                        size: 24,
                      ),
                      isDense: true,
                      alignLabelWithHint: true),
                  validator: (value) {
                    if (value.isEmpty) return "El campo no puede estar vacío.";
                    if (!PHONE_REGEX.hasMatch(value))
                      return "Número no válido.";
                    if (!conditionAccepted)
                      return "Debes aceptar los términos y condiciones.";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "Acepto los ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'términos y condiciones.',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      {showTermsAndContidionDialog(context)},
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Checkbox(
                          value: conditionAccepted,
                          onChanged: (value) {
                            setState(() {
                              conditionAccepted = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Center(
                  child: Column(
                children: [
                  Form(
                    key: _codeFormKey,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _codeController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      focusNode: _focusCodeField,
                      autofocus: false,
                      maxLength: 6,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: 4,
                          fontSize: 24),
                      decoration: InputDecoration(
                          hintText: "******",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          prefixIcon: Icon(
                            Icons.input,
                            color: Colors.black,
                            size: 24,
                          ),
                          isDense: true,
                          alignLabelWithHint: true),
                      validator: (value) {
                        if (value.isEmpty)
                          return "El campo no puede estar vacío.";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: TextButton(
                      onPressed: () {
                        if (_codeFormKey.currentState.validate()) {
                          _sendCode();
                        }
                      },
                      child: Text(
                        "Enviar",
                        style: TextStyle(fontSize: 22),
                      ),
                      style: TextButton.styleFrom(
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                          padding: EdgeInsets.all(16),
                          primary: Colors.black,
                          backgroundColor: Colors.blue),
                    ),
                  )
                ],
              )),
              Spacer(flex: 3)
            ],
          ),
          showLoading
              ? Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container()
        ],
      )),
    );
  }

  void receiveSMS() {
    if (_buttonEnabled) {
      if (_phoneFormKey.currentState.validate() && conditionAccepted == true) {
        setState(() {
          showLoading = true;
        });
        verifyPhone();
        //Send sms code
        FocusScope.of(context).requestFocus(FocusNode());
        this._buttonToggleAvilability();
        startTimer();
      }
    }
  }

  void verifyPhone() async {
    final String phoneNumberE164 = "+34" + _phoneController.text;
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumberE164,
        autoRetrievedSmsCodeForTesting: "+34645962530", // only testing
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            showLoading = false;
          });
          try {
            _signinWithPhoneAuthCredential(phoneAuthCredential);
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } catch (e) {
            print("err: $e");
          }
        },
        verificationFailed: (FirebaseAuthException e) async {
          setState(() {
            showLoading = false;
          });
          print("err: ${e.message}");
          OkAlertDialog(
              "Error", "${e.message}", () => {Navigator.of(context).pop("ok")});
        },
        codeSent: (String verificationId, int resendingToken) async {
          setState(() {
            showLoading = false;
            verificationId = verificationId;
          });
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: _codeController.text);
          await _firebaseAuth.signInWithCredential(credential);
        },
        //after the time out..60 seconds this method is called
        codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("OTP error: se acabó el tiempo"),
          ));
          print("err: ${codeAutoRetrievalTimeout.toString()}");
        });
  }

  void _sendCode() async {
    try {
      print("code: ${_codeController.text}");
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: _codeController.text);
      _signinWithPhoneAuthCredential(phoneAuthCredential);
    } catch (e) {
      print("err: $e");
    }
  }

  void _resetButtonCounter() {
    _secsButtonAvailable = 60;
  }

  void _signinWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        print("Ha entrado: ${authCredential.user}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      OkAlertDialog(
          "Error", e.message, () => {Navigator.of(context).pop("ok")});
    } finally {
      setState(() {
        showLoading = false;
      });
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_secsButtonAvailable == 0) {
          setState(() {
            timer.cancel();
            _resetButtonCounter();
            this._buttonToggleAvilability();
          });
        } else {
          setState(() {
            _secsButtonAvailable--;
            print("sec: $_secsButtonAvailable");
          });
        }
      },
    );
  }

  void showTermsAndContidionDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return termsConditionDialog(context);
      },
    );
  }

  Widget termsConditionDialog(context) {
    return Container(
        child: Center(
      child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString("assets/terms.txt"),
          builder: (context, snapshot) {
            var terms = snapshot.data.toString();
            if (snapshot.hasData) {
              return AlertDialog(
                title: Text("Términos y condiciones"),
                content: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("$terms"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              conditionAccepted = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar"),
                          style: TextButton.styleFrom(
                              shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                              padding: EdgeInsets.all(16),
                              primary: Colors.black,
                              backgroundColor: Colors.blue),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              conditionAccepted = true;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Aceptar"),
                          style: TextButton.styleFrom(
                              shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                              padding: EdgeInsets.all(16),
                              primary: Colors.black,
                              backgroundColor: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
              );
            } else {
              return Text("");
            }
          }),
    ));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
