import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  static const btnBackgroundColor = Color(0xFF2ec4b6);
  static const btnForegroundColor = Color(0xFF212121);
  static const backgroundLight = Color(0xFFf1f1f1);
}

extension CustomColorScheme on ColorScheme {
  Color get mainBackground => brightness == Brightness.light
      ? const Color(0xFFffffff)
      : const Color(0xFF212121);
  Color get mainForeground =>
      brightness == Brightness.light ? Color(0xFF010101) : Color(0xFFf1f1f1);
  LinearGradient get mainBackgroundLinearGradient =>
      brightness == Brightness.light
          ? ConstantColors.backgroundLinearGradientLight
          : ConstantColors.backgroundLinearGradientDark;
}
