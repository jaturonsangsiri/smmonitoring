import 'package:flutter/material.dart';

class Responsive {
  static late bool isTablet;
  static late double width;
  static late double height;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    isTablet = mediaQuery.size.width > 700 ? true : false;
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
  } 
}