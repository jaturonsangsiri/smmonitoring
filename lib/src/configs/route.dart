import 'package:smmonitoring/src/pages/device_detail_legacy_page.dart';
import 'package:smmonitoring/src/pages/device_detail_page.dart';
import 'package:smmonitoring/src/pages/home_page.dart';
import 'package:smmonitoring/src/pages/login_page.dart';
import 'package:smmonitoring/src/pages/notification_page.dart';
import 'package:smmonitoring/src/pages/register_page.dart';
import 'package:flutter/material.dart';

class Route {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static const home = '/';
  static const login = '/login';
  static const notification = '/notification';
  static const register = '/register';
  static const device = '/device';
  static const deviceLegacy = '/deviceLegacy';

  static Map<String, WidgetBuilder> getAll() => _route;

  static final Map<String, WidgetBuilder> _route = {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    notification: (context) => NotificationPage(),
    register: (context) => const RegisterPage(),
    device: (context) => DevicedetailPage(),
    deviceLegacy: (context) => DeviceDetailLegacyPage()
  };
}
