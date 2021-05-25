import 'package:flutter/material.dart';
import 'package:flutter_sms_auth1/shared/colors.dart';

class CustomTextStyles {
  TextStyle onboardingTitleStyle(context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.mainForeground,
        fontWeight: FontWeight.bold,
        fontSize: 24);
  }

  TextStyle onboardingBodyStyle(context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.mainForeground,
        fontWeight: FontWeight.normal,
        fontSize: 12);
  }

  TextStyle onboardingBtnTextStyle(context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.mainForeground,
      fontSize: 16,
    );
  }
}
