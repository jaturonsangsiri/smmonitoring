import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:smmonitoring/firebase_options.dart';
import 'package:smmonitoring/src/app.dart';
import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/notification/notification_bloc.dart';
import 'package:smmonitoring/src/bloc/probe/probe_setting_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/services/firebase_api.dart';
import 'package:smmonitoring/src/services/network.dart';
import 'package:smmonitoring/src/services/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print("BG Notification Title: ${message.notification?.title}");
    print("BG Notification Body: ${message.notification?.body}");
    print("BG Notification Data: ${message.data}");
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // จัดการเกี่ยวกับหน้า Splash Screen (หน้าโหลดก่อนเข้าแอป)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
  String route = "/";
  if (connectivityResult.contains(ConnectivityResult.none)) {
    route = "/error";
  } else {
    HttpOverrides.global = PostHttpOverrides();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final firebaseApi = FirebaseApi();
    final configStorage = ConfigStorage();
    await firebaseApi.initNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? token = await configStorage.getAccessToken();
    if (token == null) {
      await configStorage.clearTokens();
      route = "/login";
    }
  }

  // ทำการโหลดข้อมูลที่ต้องการใช้งานก่อนเข้าแอป
  final configStorage = ConfigStorage();
  bool theme = await configStorage.getTheme() ?? false;

  // ดึง Bloc ทั้งหมดมา
  // Bloc ตัวตั้งค่าโพรบ
  final probeBloc = BlocProvider<ProbeSettingBloc>(create: (context) => ProbeSettingBloc());
  final devicesBloc = BlocProvider<DevicesBloc>(create: (context) => DevicesBloc());
  final userBloc = BlocProvider<UsersBloc>(create: (context) => UsersBloc());
  final notificationBloc = BlocProvider(create: (context) => NotificationBloc());
  final themeBloc = BlocProvider(create: (context) => ThemeBloc());

  // ปรับให้แอปเป็นแนวตั้งเท่านั้น
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  FlutterNativeSplash.remove();
  runApp(
    MultiBlocProvider(
      providers: [probeBloc, devicesBloc, userBloc, notificationBloc, themeBloc], 
      child: App(theme: theme, path: route),
    ),
  );
}