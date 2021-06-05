import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Shared/alert_dialog.dart';
import 'package:flutter_sms_auth1/Shared/colors.dart';
import 'package:flutter_sms_auth1/Shared/styles.dart';
import 'package:flutter_sms_auth1/ViewModel/login_vm.dart';
import 'package:provider/provider.dart';

// add google verification in spainish
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusPhoneField = new FocusNode();
  final FocusNode _focusCodeField = new FocusNode();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LoginObservable>(context, listen: false)
        .initAuthService(context);
  }

  @override
  Widget build(BuildContext context) {
    var loginObservable = Provider.of<LoginObservable>(context, listen: true);
    print("Rendering login screen");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconTheme.of(context),
          title: Text(
            "Acceso a la solicitud de citas",
            style: TextStyle(
                color: Theme.of(context).colorScheme.foregroundTxtButtonColor),
          ),
          backgroundColor: ConstantColors.mainColorApp,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: double.infinity,
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
                        showCursor: true,
                        cursorColor: ConstantColors.mainColorApp,
                        keyboardType: TextInputType.phone,
                        controller: loginObservable.phoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          new CustomInputFormatter(),
                          LengthLimitingTextInputFormatter(
                              11) //phone number(9) + separation every 3 chars (2)
                        ],
                        focusNode: _focusPhoneField,
                        //autofocus: false,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.myBlack,
                            fontSize: 24),
                        decoration: InputDecoration(
                            suffix: TextButton(
                              onPressed: () {
                                if (_phoneFormKey.currentState.validate() &&
                                    loginObservable.termsAccepted == true) {
                                  loginObservable.receiveSMS(context);
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: Consumer<LoginObservable>(
                                builder: (context, data, _) => Text(
                                  data.buttonEnabled
                                      ? "Recibir SMS"
                                      : "${data.secsButtonAvailable} sec SMS",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  )),
                                  padding: EdgeInsets.all(12),
                                  primary: Colors.black,
                                  backgroundColor: loginObservable.buttonEnabled
                                      ? ConstantColors.mainColorApp
                                      : Colors.grey),
                            ),
                            hintText: "645 962 530", // Use company number
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0),
                            prefixIcon: Icon(
                              Icons.mobile_friendly,
                              color: ConstantColors.mainColorApp,
                              size: 24,
                            ),
                            isDense: true,
                            alignLabelWithHint: true),
                        validator: (value) {
                          if (value.isEmpty)
                            return "El campo no puede estar vacío.";
                          if (!loginObservable.PHONE_REGEX.hasMatch(value))
                            return "Número no válido.";
                          if (!loginObservable.termsAccepted)
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
                                        ..onTap = () => {
                                              showTermsAndContidionDialog(
                                                  context)
                                            },
                                      style: TextStyle(
                                          color: ConstantColors.mainColorApp),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Checkbox(
                                value: loginObservable.termsAccepted,
                                activeColor: ConstantColors.mainColorApp,
                                onChanged: (value) {
                                  setState(() {
                                    loginObservable.termsAccepted = value;
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
                            showCursor: true,
                            cursorColor: ConstantColors.mainColorApp,
                            keyboardType: TextInputType.phone,
                            controller: loginObservable.codeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            focusNode: _focusCodeField,
                            //autofocus: false,
                            maxLength: 6,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ConstantColors.myBlack,
                                letterSpacing: 4,
                                fontSize: 24),
                            decoration: InputDecoration(
                                hintText: "******",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                                prefixIcon: Icon(
                                  Icons.input,
                                  color: ConstantColors.mainColorApp,
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
                        Container(
                          margin: EdgeInsets.only(top: 32.0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextButton(
                                onPressed: () {
                                  if (_codeFormKey.currentState.validate() &&
                                      _phoneFormKey.currentState.validate() &&
                                      loginObservable.termsAccepted) {
                                    loginObservable.sendCodeOTP();
                                  }
                                },
                                child: Text(
                                  "Enviar",
                                  style: CustomTextStyles()
                                      .onboardingBtnTextStyle(context),
                                ),
                                style: TextButton.styleFrom(
                                    shape: (RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )),
                                    padding:
                                        EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    backgroundColor:
                                        ConstantColors.mainColorApp),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                    Spacer(flex: 3)
                  ],
                ),
                loginObservable.authService.showLoading
                    ? CircularIndicatorAlertDialog()
                    : Container()
              ],
            ),
          ),
        ));
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
    var loginObservable = Provider.of<LoginObservable>(context, listen: false);
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
                    Text(
                      "$terms",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: "CormorantGaramond"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              loginObservable.termsAccepted = false;
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
                              backgroundColor: ConstantColors.mainColorApp),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              loginObservable.termsAccepted = true;
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
                              backgroundColor: ConstantColors.mainColorApp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\© Copyright 2021",
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w300,
                          fontFamily: "CormorantGaramond"),
                    ),
                  ],
                )),
              );
            } else {
              return CircularIndicatorAlertDialog();
            }
          }),
    ));
  }

  @override
  void dispose() {
    try {
      Provider.of<LoginObservable>(context, listen: false).timer.cancel();
    } catch (e) {
      print("err $e");
    }
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
