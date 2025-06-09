import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smmonitoring/src/services/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:smmonitoring/src/constants/timer.dart';
import 'package:smmonitoring/src/configs/url.dart';
import 'package:smmonitoring/src/models/legacy_device.dart';
import 'package:smmonitoring/src/models/legacy_notification.dart';
import 'package:smmonitoring/src/models/log.dart';
import 'package:smmonitoring/src/models/models.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class Api {
  final Dio _dio = Dio();
  final ConfigStorage _tokenStorage = ConfigStorage();

  Api() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _tokenStorage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        options.baseUrl = URL.BASE_URL;
        options.validateStatus = (status) => status != null && status < 400;
        options.headers["Content-Type"] = "application/json";
        options.connectTimeout = Timer.CONNECT_TIMEOUT;
        options.receiveTimeout = Timer.RECEIVE_TIMEOUT;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401 && !error.requestOptions.path.contains('/auth/refresh')) {
          try {
            final newToken = await refreshToken();
            if (newToken != null) {
              final newRequest = error.requestOptions;
              newRequest.headers['Authorization'] = 'Bearer $newToken';
              newRequest.baseUrl = URL.BASE_URL;
              newRequest.validateStatus = (status) => status != null && status < 400;
              newRequest.headers["Content-Type"] = "application/json";
              newRequest.connectTimeout = Timer.CONNECT_TIMEOUT;
              newRequest.receiveTimeout = Timer.RECEIVE_TIMEOUT;
              final response = await _dio.fetch(newRequest);
              return handler.resolve(response);
            } else {
              await _tokenStorage.clearTokens();
              custom_route.Route.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
              return;
            }
          } catch (err) {
            await _tokenStorage.clearTokens();
            custom_route.Route.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
            return;
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> refreshToken() async {
    try {
      final String? refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }
      final Response response = await _dio.post('/auth/refresh', data: {'token': refreshToken});
      Refresh token = Refresh.fromJson(json.decode(jsonEncode(response.data)));
      await _tokenStorage.saveTokens(token.data!.token!, token.data!.refreshToken!);
      return token.data!.token!;
    } on DioException catch (error) {
      if (kDebugMode) print(error.message);
      throw Exception(error);
    }
  }

  Future<Login> checkLogin(String username, String password) async {
    try {
      final Response response = await _dio.post('/auth/login', data: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        Login user = Login.fromJson(json.decode(jsonEncode(response.data)));
        String topic = "";
        await _tokenStorage.saveTokens(user.data!.token!, user.data!.refreshToken!);
        switch (user.data!.role) {
          case "SERVICE":
            topic = "service";
            break;
          case "ADMIN":
            topic = user.data!.hosId!;
            break;
          case "LEGACY_ADMIN":
            topic = user.data!.hosId!;
            break;
          case "USER":
            topic = user.data!.wardId!;
            break;
          case "LEGACY_USER":
            topic = user.data!.wardId!;
            break;
          case "GUEST":
            topic = user.data!.wardId!;
            break;
          default:
            topic = "admin";
            break;
        }
        await _tokenStorage.saveUser(user.data!.id!, user.data!.role!);
        await _tokenStorage.saveTopic(topic, "$topic-door");
        if (user.data!.role == "SERVICE" || user.data!.role == "SUPER") {
          await _tokenStorage.saveLegacyTopic("$topic-legacy");
          _tokenStorage.setLegacyNotification(true);
        }
        await _tokenStorage.setNotification(true);
        await _tokenStorage.setDoorNotification(true);
        return user;
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (error) {
      if (kDebugMode) print(error.response?.data['message'] ?? error);
      throw Exception(error.response?.data['message'] ?? 'Unknown error occurred');
    }
  }

  Future<UserData?> getUser() async {
    try {
      final userId = await _tokenStorage.getUserId();
      if (userId == null) {
        throw Exception('Failed to get user data');
      }
      final Response response = await _dio.get('/auth/user/$userId');
      if (response.statusCode == 200 && response.data != null) {
        User user = User.fromJson(json.decode(jsonEncode(response.data)));
        return user.data!;
      } else {
        throw Exception('Failed to get user data');
      }
    } on DioException catch (error) {
      if (kDebugMode) print(error.message);
      throw Exception(error);
    }
  }

  Future<bool> register(String username, String password, String display) async {
    try {
      final Response response = await _dio.post('/auth/register', data: {
        'username': username,
        'password': password,
        'display': display,
        'wardId': 'WID-GUEST',
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (error) {
      if (kDebugMode) print(error.message);
      throw Exception(error);
    }
  }

  Future<bool> updateUser(String userId, UserData user) async {
    try {
      final Response response = await _dio.put('/auth/user/$userId', data: user.toJsonDisplayname());
      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(jsonEncode(response.data)));
        if (kDebugMode) print(user.data!.display);
        return true;
      } else {
        throw Exception('Failed to update user');
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final Response response = await _dio.delete('/auth/user/$userId');
      if (response.statusCode! < 400) {
        return true;
      } else {
        throw Exception('Failed to delete user');
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> changPass(String userId, ChangePassword pass) async {
    try {
      await _dio.patch('/auth/reset/$userId', data: {'password': pass.password, 'oldPassword': pass.oldPassword});
      return true;
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<List<NotiList>> getNotification() async {
    try {
      const String uri = '/log/mobile';
      final Response response = await _dio.get(uri, options: Options(validateStatus: (_) => true));
      if (response.statusCode == 200) {
        Notifications value = Notifications.fromJson(json.decode(jsonEncode(response.data)));
        return value.data!;
      } else {
        return [];
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<List<LegacyNotificationList>> getLegacyNotification([String? device]) async {
    try {
      final String uri = device == null ? '/legacy/mobile' : '/legacy/mobile?device=$device';
      final Response response = await _dio.get(uri, options: Options(validateStatus: (_) => true));
      if (response.statusCode == 200) {
        LegacyNotification value = LegacyNotification.fromJson(json.decode(jsonEncode(response.data)));
        return value.data!;
      } else {
        return [];
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<List<DeviceInfo>> getDevice(String ward) async {
    try {
      final Response response = await _dio.get('/log/mobile/$ward', options: Options(validateStatus: (_) => true));
      if (response.statusCode == 200) {
        MobileLog value = MobileLog.fromJson(response.data!);
        return value.data!;
      } else {
        return [];
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<List<DeviceLegacyList>> getLegacyDevice(String ward) async {
    try {
      final Response response = await _dio.get('/legacy/mobile/$ward', options: Options(validateStatus: (_) => true));
      if (response.statusCode == 200) {
        DeviceLegacy value = DeviceLegacy.fromJson(response.data!);
        return value.data!;
      } else {
        return [];
      }
    } on DioException catch (error) {
      throw Exception(error);
    }
  }

  Future<DeviceId?> getDeviceById(String id) async {
    try {
      final Response response = await _dio.get('/devices/device/$id', options: Options(validateStatus: (_) => true));
      if (response.statusCode == 200) {
        Device value = Device.fromJson(response.data!);
        return value.data;
      } else {
        return null;
      }
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  Future<List<HospitalData>> getHospital() async {
    try {
      final Response response = await _dio.get('/auth/hospital');
      if (response.statusCode == 200) {
        Hospital value = Hospital.fromJson(json.decode(jsonEncode(response.data)));
        return value.data ?? [];
      } else {
        return [];
      }
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> updateProbe(String probId, Probe probe) async {
    try {
      final Response response = await _dio.put('/devices/probe/$probId', data: probe.toPayloadJson());
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update probe');
      }
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> uploadImage(File? image, String userID) async {
    if (image == null) return false;

    String mimeType = "";
    String fileExtension = image.path.split('.').last.toLowerCase();

    switch (fileExtension) {   
      case 'png':
        mimeType = "image/png"; 
        break;
      case 'jpeg':
        mimeType = "image/jpeg"; // fallback เป็น jpeg
        break;
      case 'jpg':
        mimeType = "image/jpg"; // fallback เป็น jpg
        break;
      case 'gif':
        mimeType = "image/gif"; // fallback เป็น jpeg
        break;
      default:
        throw Exception(['error image type not allow!.']);
    }

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      ),
    });

    try {
      Response response = await _dio.put(
        "/auth/user/$userID",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print("Upload success: ${response.data}");
        return true;
      } else {
        if (kDebugMode) print("Upload failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      if (kDebugMode) print("Upload error: $e");
      return false;
    }
  }
}
