import 'dart:async';

import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/services/mqtt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class RealTemp extends StatefulWidget {
  final String devSerial;
  final String probe;
  const RealTemp({super.key, required this.devSerial, required this.probe});

  @override
  State<RealTemp> createState() => _RealTempState();
}

class _RealTempState extends State<RealTemp> {
  final client = MqttService();
  Timer? _timer;
  double temp = 0.0;
  double humi = 0.0;
  
  @override
  void initState() {
    super.initState();
    client.connect().then((value) {
      if (value) {
        client.subscribe("${widget.devSerial}/temp/real");
        client.subscribe("${widget.devSerial}/${widget.probe}/temp/real");
        client.publish("${widget.devSerial}/temp", "on");
        client.publish("siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/temp", "on");
        client.publish("siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/${widget.probe}/temp", "on");
        _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
          client.publish("${widget.devSerial}/temp", "on");
          client.publish("siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/temp", "on");
          client.publish("siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/${widget.probe}/temp", "on");
        });
      }
    });
    client.messageStream.listen((event) {
      if (kDebugMode) print(event['temp']);
      if (kDebugMode) print(event['humi']);
      setState(() {
        temp = event['temp'] ?? 0.0;
        humi = event['humi'] ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    client.publish('${widget.devSerial}/temp', "off");
    client.publish('siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/temp', "off");
    client.publish("siamatic/${client.getDevice(widget.devSerial)}/${widget.devSerial}/${widget.probe}/temp", "off");
    client.unsubscribe("${widget.devSerial}/temp/real");
    client.unsubscribe("${widget.devSerial}/${widget.probe}/temp/real");
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSensorReading(
          icon: FontAwesomeIcons.temperatureHalf,
          label: 'อุณหภูมิ',
          value: '${temp.toStringAsFixed(2)}°C',
          color: Colors.orange,
        ),
        _buildSensorReading(
          icon: FontAwesomeIcons.droplet,
          label: 'ความชื้น',
          value: '${humi.toStringAsFixed(2)}%',
          color: Colors.blue,
        ),
      ],
    );
  }

  // Widget สำหรับสดงข้อมูลอุณหภูมิและความชื้นของอุปกรณ์
  Widget _buildSensorReading({required IconData icon, required String label, required String value, required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: Responsive.isTablet ? 70 : 50),
        SizedBox(height: 4),
        BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) => Text(label, style: TextStyle(fontSize: Responsive.isTablet ? 20 : 16,fontWeight: FontWeight.w600,color: themeState.themeApp? Colors.white : Colors.black))),
        Text(value, style: TextStyle(fontSize: Responsive.isTablet ? 60 : 40,fontWeight: FontWeight.bold,color: color)),
      ],
    );
  }
}