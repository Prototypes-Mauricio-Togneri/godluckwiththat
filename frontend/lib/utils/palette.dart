import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;

  static Color divider1 = const Color(0xff555555);

  static Color backgroundTransparent1 = const Color(0xff000000).withAlpha(150);
  static Color backgroundTransparent2 = const Color(0xff1a1a1a).withAlpha(150);
  static Color backgroundTransparent3 = const Color(0xff555555).withAlpha(150);
  static Color backgroundClose = const Color(0xffcc4b4b);
  static Color backgroundTopBar = const Color(0xff25272c);
  static Color backgroundTopBarContainer = const Color(0xff393d45);

  // TODO(momo): rename
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xff404040);
  static const Color lightGrey = Color(0xffa0a0a0);
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color producerBlock = Color(0xffe0e0e0);
}
