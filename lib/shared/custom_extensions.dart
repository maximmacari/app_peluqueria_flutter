import 'package:flutter/material.dart';

extension ToggleExtension on bool {
  bool toggle() => !this;
}

extension StringExtension on String {
  String capitalized() => "${this[0].toUpperCase()}${this.substring(1)}";
}