import 'package:flutter/material.dart';


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


class CircularIndicatorAlertDialog extends StatelessWidget {
  
  CircularIndicatorAlertDialog(){}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(),
          ),
        ],
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