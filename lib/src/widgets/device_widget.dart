// Widget ของอุปกรณ์ที่แสดงในแอปพลิเคชั่น
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/models.dart';
import 'package:smmonitoring/src/widgets/device/noti.dart';
import 'package:smmonitoring/src/widgets/device/temp_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class DeviceStatus extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String status;
  final double fontSize;
  const DeviceStatus({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.status,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
      child: Text(status, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}

// แสดงข้อมูลรายละเอียดของอุปกรณ์หน้า DeviceDetailWidget_page.dart
class DeviceDetailWidget extends StatelessWidget {
  final Probe data;
  final String devSerial;
  final String probe;
  const DeviceDetailWidget({super.key, required this.data, required this.devSerial, required this.probe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(
            height: Responsive.isTablet ? 340 : 260,
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return Card(
                  elevation: 3,
                  color: themeState.themeApp? boxColorDark : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(padding: const EdgeInsets.all(16), child: TempInfo(deviceData: data, devSerial: devSerial, probe: probe)),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // รายการแจ้งเตือนของอุปกรณ์นี้
          Noti(devSerial: devSerial),
        ],
      ),
    );
  }

  // ฟังก์ชั่นแยกสีตามสถานะของอุปกรณ์
  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.green;
      case 'Offline':
        return Colors.red;
      case 'Maintenance':
        return Colors.yellow.shade600;
      case 'Error':
        return Colors.orange.shade600;
      default:
        return Colors.grey;
    }
  }
}
