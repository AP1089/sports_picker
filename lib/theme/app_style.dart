import 'dart:ui';
import 'package:flutter/material.dart';

class AppStyle {
  static const String font = "Audiowide";

  static const Color green = Color(0x9900FF00);
  static const Color blue = Color(0xD900C8FF);
  static const Color gray = Colors.grey;
  static const Color darkGray = Color(0xFF686868);
  static const Color backgroundBlack = Color(0xFF282828);
  static const Color black = Colors.black;

  static TextStyle mediumTextStyleGray = TextStyle(
      color: gray, fontSize: 16, fontFamily: font, fontWeight: FontWeight.w700);

  static TextStyle mediumTextStyleBlue = TextStyle(
      color: blue, fontSize: 16, fontFamily: font, fontWeight: FontWeight.w700);

  static TextStyle titleTextStyleGreen =
      TextStyle(color: green, fontSize: 18, fontFamily: font);

  static TextStyle titleTextStyleDarkGray =
      TextStyle(color: darkGray, fontSize: 18, fontFamily: font);

  static TextStyle bodyTextStyleGray = TextStyle(
      color: gray, fontSize: 14, fontFamily: font, fontWeight: FontWeight.w700);
}
