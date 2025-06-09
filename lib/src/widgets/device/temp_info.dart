import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/models/devices.dart';
import 'package:smmonitoring/src/widgets/device/real_temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class TempInfo extends StatelessWidget {
  final Probe deviceData;
  final String devSerial;
  final String probe;
  const TempInfo({super.key, required this.deviceData, required this.devSerial, required this.probe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // อุณหภูมิ / ความชื้น
        RealTemp(probe: probe, devSerial:  devSerial),
        SizedBox(height: 30),
        // ช่วงค่าที่รองรับ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRangeColumn(
              'ช่วงอุณหภูมิ',
              '${deviceData.tempMin}°C ถึง ${deviceData.tempMax}°C',
            ),
            _buildRangeColumn(
              'ช่วงความชื้น',
              '${deviceData.humiMin}% ถึง ${deviceData.humiMax}%',
            ),
          ],
        ),
      ],
    );
  }

  // Widget สำหรับแสดงช่วงค่าที่รองรับ
  Widget _buildRangeColumn(String title, String value) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600,fontSize: Responsive.isTablet ? 20 : 15,color: themeState.themeApp? Colors.white : Colors.black)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: Responsive.isTablet ? 23 : 18, color: themeState.themeApp? Colors.white70 : Colors.grey[700])),
          ],
        );
      },
    );
  }
}
