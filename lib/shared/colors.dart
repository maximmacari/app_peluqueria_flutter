import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConstantColors {
  static const backgroundLinearGradientLight = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.1,
        0.4,
        0.7,
        0.9
      ],
      colors: [
        Color(0xFFda055d),
        Color(0xFFee3a85),
        Color(0xFFc13770),
        Color(0xFFbd4979)
      ]);

  static const backgroundLinearGradientDark = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [
        0.1,
        0.9
      ],
      colors: [
        Color(0xFF434343),
        Color(0xFF111222),
      ]);
}

extension CustomColorScheme on ColorScheme {
  Color get mainBackground => brightness == Brightness.light
      ? const Color(0xFFe8005b)
      : const Color(0xFF222222);
  Color get mainForeground =>
      brightness == Brightness.light ? Colors.black : Colors.white;
  LinearGradient get mainBackgroundLinearGradient => brightness == Brightness.light
      ? ConstantColors.backgroundLinearGradientLight
      : ConstantColors.backgroundLinearGradientDark;
}
