import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  String? apnsToken;

  Future<void> initNotifications() async {
    apnsToken = await firebaseMessaging.getAPNSToken();
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("Message: ${message.notification?.title}");
        print("Message: ${message.notification?.body}");
        print("Message: ${message.data.toString()}");
      }
      ShowSnackbar.snackbar(
        ContentType.success,
        message.notification?.title ?? "ไม่มีข้อมูล",
        message.notification?.body ?? "ไม่มีข้อมูล",
      );
    });
    
  }

  Future<void> subscribeTopic(String topic) async {
    try {
      if (Platform.isIOS) {
        if (apnsToken != null) {
          await firebaseMessaging.subscribeToTopic(topic);
        } else {
          apnsToken = await firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            await firebaseMessaging.subscribeToTopic(topic);
          } else {
            await Future<void>.delayed(const Duration(seconds: 3));
            apnsToken = await firebaseMessaging.getAPNSToken();
            if (apnsToken != null) await firebaseMessaging.subscribeToTopic(topic);
          }
        }
        if (kDebugMode) print("Subscribed to $topic");
      } else {
        await firebaseMessaging.subscribeToTopic(topic);
        if (kDebugMode) print("Subscribed to $topic");
      }
    } catch (error) {
      if (kDebugMode) print(error.toString());
    }
  }

  Future<void> unSubscribeTopic(String topic) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) print("Unsubscribed from $topic");
    } catch (error) {
      if (kDebugMode) print(error.toString());
    }
  }

  void onMessage(RemoteMessage message) {
    if (kDebugMode) {
      print("Message: ${message.notification?.title}");
      print("Message: ${message.notification?.body}");
      print("Message: ${message.data.toString()}");
    }
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print("Bg Message: ${message.notification?.title}");
      print("Bg Message: ${message.notification?.body}");
      print("Bg Message: ${message.data.toString()}");
    }
  }
}
