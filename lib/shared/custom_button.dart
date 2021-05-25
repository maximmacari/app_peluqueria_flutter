import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'colors.dart';
import 'styles.dart';

class TxtButtonIcon extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String labelString;
  final IconData icon;

  TxtButtonIcon(
      {@required this.onPressed,
      @required this.labelString,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Theme.of(context).colorScheme.mainForeground,
        onPressed: this.onPressed,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${this.labelString}",
                  style: CustomTextStyles().onboardingBtnTextStyle(context)),
              Icon(
                icon,
                color: Theme.of(context).colorScheme.mainForeground,
              ),
            ],
          ),
        ));
  }
}

class SimpleButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String labelString;

  SimpleButton({@required this.onPressed, @required this.labelString});

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.all(16),
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.mainBackground,
                blurRadius: 40,
                offset: Offset(5, 5),
                spreadRadius: -2
                // Shadow position
                ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              child: Text(this.labelString,
                  style: CustomTextStyles().onboardingBtnTextStyle(context)),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.mainForeground,
                //minimumSize: Size(88, 36),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                backgroundColor: Colors
                    .black54, //Theme.of(context).colorScheme.mainBackground,
                shadowColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onPressed: () => null),
        ]));
  }
}
