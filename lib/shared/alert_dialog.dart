import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/Shared/colors.dart';

class OkAlertDialog extends StatelessWidget {
  String _description;
  String _title;
  Function _okCallBack;

  OkAlertDialog(String title, String description, Function okCallBack) {
    this._title = title;
    this._description = description;
    this._okCallBack = okCallBack;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$_title"),
      content: Text("$_description"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: _okCallBack,
        )
      ],
    );
  }
}

CircularIndicatorAlertDialog showCircularIndicatorAlertDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CircularIndicatorAlertDialog();
      },
    );
  }

class CircularIndicatorAlertDialog extends StatelessWidget {
  CircularIndicatorAlertDialog() {}

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: ConstantColors.mainColorApp.withOpacity(0.06),
              spreadRadius: 2,
              blurRadius: 60,
              offset: Offset(-2, -2)),
          BoxShadow(
              color: ConstantColors.mainColorApp.withOpacity(0.06),
              spreadRadius: 2,
              blurRadius: 60,
              offset: Offset(2, 2))
        ]),
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: Container(
                width: 250.0,
                height: 100.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ConstantColors.mainColorApp),
                      ),
                      Spacer(
                        flex: 4,
                      ),
                      Text(
                        "Cargando...",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Spacer()
                    ]))),
      ),
    );
  }
}

class CancelAlertDialog extends StatelessWidget {
  String _description;
  String _title;
  Function _cancelCallBack;
  Function _okCallBack;

  CancelAlertDialog(String title, String description, Function okCallBack,
      Function cancelCallBack) {
    this._title = title;
    this._description = description;
    this._cancelCallBack = cancelCallBack;
    this._okCallBack = okCallBack;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$_title"),
      content: Text("$_description"),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: _cancelCallBack,
        ),
        TextButton(
          child: Text("Continue"),
          onPressed: _okCallBack,
        ),
      ],
    );
  }
}


//OkAlertDialog("Error", "Field is required", () => {Navigator.of(context).pop("ok")});