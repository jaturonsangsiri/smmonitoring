import 'dart:async';
import 'dart:convert';
import 'package:smmonitoring/src/models/temp.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smmonitoring/src/configs/mqtt_config.dart';

class MqttService {
  late MqttServerClient _client;
  final StreamController<Map<String, double>> _messageController = StreamController.broadcast();
  Stream<Map<String, double>> get messageStream => _messageController.stream;

  MqttService() {
    _client = MqttServerClient(MqttConf.MQTT_SERVER, 'mobile-${const Uuid().v4()}')
      ..autoReconnect = true
      ..keepAlivePeriod = 60
      ..port = MqttConf.MQTT_PORT
      ..onConnected = onConnected
      ..onDisconnected = onDisConnected
      ..secure = true;
  }

  Future<bool> connect() async {
    try {
      await _client.connect(MqttConf.MQTT_USERNAME, MqttConf.MQTT_PASSWORD);
      if (_client.connectionStatus?.state == MqttConnectionState.connected) {
        if (kDebugMode) print('Connected to MQTT broker');
        _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
          for (var message in messages!) {
            final payload = message.payload as MqttPublishMessage;
            final msg = MqttPublishPayload.bytesToStringAsString(payload.payload.message);
            Temp tempInfo = Temp.fromJson(json.decode(msg));
            _messageController.add({'temp': tempInfo.temp?.toDouble() ?? 0.0, 'humi': tempInfo.humi?.toDouble() ?? 0.0});
          }
        });
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('MQTT connection error: $e');
    }
    return false;
  }

  void disconnect() {
    _client.disconnect();
  }

  void publish(String topic, String message) {
    if (kDebugMode) print('Publishing to topic: $topic with message: $message');
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    builder.clear();
  }

  void subscribe(String topic) {
    if (kDebugMode) print('Subscribing to topic: $topic');
    _client.subscribe(topic, MqttQos.atMostOnce);
  }

  void unsubscribe(String topic) {
    if (kDebugMode) print('Unsubscribing from topic: $topic');
    _client.unsubscribe(topic);
  }

  String getDevice(String device) {
    String product = device.substring(0, 3) == "iTS" ? 'items' : 'etemp';
    String version = device.substring(3, 5).toLowerCase();
    return "$product/$version";
  }

  void onConnected() {
    if (kDebugMode) print('MQTT Connected');
  }

  void onDisConnected() {
    if (kDebugMode) print('MQTT Disconnected');
  }
}
