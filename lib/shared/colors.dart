import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ConstantColors {
  static const backgroundLinearGradientLight = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.7],
      colors: [Color(0xFFffffff), Color(0xFFf1f1f1)]);

  static const backgroundLinearGradientDark = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.1,
        0.7
      ],
      colors: [
        Color(0xFF434343),
        Color(0xFF111222),
      ]);
  
  static const myWhite = Color(0xFFf1f1f1);
  static const myBlack = Color(0xFF010101);
  static const mainColorApp = Color(0xFF2ec4b6);
  //static final foregroundColorButton = SchedulerBinding.instance.window.platformBrightness == Brightness.light ? Color(0xFF121212) : Color(0xFFDEE4e7);
}

extension CustomColorScheme on ColorScheme {
  Color get mainBackground => brightness == Brightness.light ? const Color(0xFFffffff) : const Color(0xFF212121);
  Color get foregroundTxtButtonColor => ConstantColors.myBlack;
  Color get foregroundPlainTxtColor => brightness == Brightness.light ? 
  ConstantColors.myBlack : ConstantColors.myWhite;
  LinearGradient get mainBackgroundLinearGradient =>
      brightness == Brightness.light
          ? ConstantColors.backgroundLinearGradientLight
          : ConstantColors.backgroundLinearGradientDark;
}
