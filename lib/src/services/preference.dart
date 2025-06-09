
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smmonitoring/src/services/firebase_api.dart';

class ConfigStorage {
  final firebase = FirebaseApi();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", accessToken);
    await prefs.setString("refresh_token", refreshToken);
  }

  Future<void> saveTopic(String topic, String doorTopic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("topic", topic);
    await prefs.setString("door_topic", doorTopic);
  }

  Future<void> saveLegacyTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("legacy_topic", topic);
  }

  Future<void> saveUser(String userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", userId);
    await prefs.setString("role", role);
  }

  Future<bool> setNotification(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final notification = await getTopic();
      if (notification == null) return false;
      if (status) {
        await firebase.subscribeTopic(notification);
        await prefs.setBool("notification", status);
        return true;
      } else {
        await firebase.unSubscribeTopic(notification);
        await prefs.setBool("notification", status);
        return false;
      }
    } on Exception catch (e) {
      if (kDebugMode) print("Error: $e");
      return false;
    }
  }

  Future<bool> setDoorNotification(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final door = await getDoorTopic();
      if (door == null) return false;
      if (status) {
        await firebase.subscribeTopic(door);
        await prefs.setBool("door_notification", status);
        return true;
      } else {
        await firebase.unSubscribeTopic(door);
        await prefs.setBool("door_notification", status);
        return false;
      }
    } on Exception catch (e) {
      if (kDebugMode) print("Error: $e");
      return false;
    }
  }

  Future<bool> setLegacyNotification(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final legacy = await getLegacyTopic();
      if (legacy == null) return false;
      if (status) {
        await firebase.subscribeTopic(legacy);
        await prefs.setBool("legacy_notification", status);
        return true;
      } else {
        await firebase.unSubscribeTopic(legacy);
        await prefs.setBool("legacy_notification", status);
        return false;
      }
    } on Exception catch (e) {
      if (kDebugMode) print("Error: $e");
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  Future<bool> getNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notification") ?? false;
  }

  Future<bool> getDoorNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("door_notification") ?? false;
  }

  Future<String?> getTopic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("topic");
  }

  Future<String?> getDoorTopic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("door_topic");
  }

  Future<String?> getLegacyTopic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("legacy_topic");
  }

  Future<bool?> getNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notification");
  }

  Future<bool?> getDoorStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("door_notification");
  }

  Future<bool?> getLegacyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("legacy_notification");
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await setNotification(false);
    await setDoorNotification(false);
    await setLegacyNotification(false);
    await prefs.clear();
  }

  Future<bool?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("theme_app");
  }

  Future<void> setTheme(bool theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("theme_app", theme);
  }
}
