import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/models/legacy_notification.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';

class DeviceDetailLegacyPage extends StatefulWidget {
  const DeviceDetailLegacyPage({super.key});

  @override
  State<DeviceDetailLegacyPage> createState() => _DeviceDetailLegacyPageState();
}

class _DeviceDetailLegacyPageState extends State<DeviceDetailLegacyPage> {
  final api = Api();
  Timer? _timer;
  List<LegacyNotificationList> legacyList = [];
  bool isLoading = true;
  Map arguments = {};
  BarCustom barCustom = BarCustom();

  Future<void> getNotification() async {
    try {
      legacyList = await api.getLegacyNotification(arguments['serial']);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch(error) {
      setState(() {
        isLoading = false;
        ShowSnackbar.snackbar(ContentType.failure, "เกิดข้อผิดพลาด", "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้");
        Navigator.pop(context);
      });
    } 
  }

  @override
  void initState() {
    super.initState();
    // Delay accessing context until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      arguments = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
      getNotification();
      _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        getNotification();
      });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Scaffold(
            appBar: barCustom.appBarCustomNoTabs(context, arguments['name'] ?? '', null),
            body: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(20),
                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 6.0),
              ),
            ),
          );
        },
      ); 
    }
    if (legacyList.isNotEmpty) { 
      return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Scaffold(
            appBar: barCustom.appBarCustomNoTabs(context, arguments['name'] ?? '', null),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: legacyList.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.black38, height: 4, indent: 15, endIndent: 15),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(legacyList[index].message ?? "- -", style: Theme.of(context).textTheme.bodyLarge), 
                        tileColor: themeState.themeApp? Color.fromRGBO(181, 181, 181, 0.5) : Colors.white, 
                        subtitle: Text(legacyList[index].probe ?? "- -", style: Theme.of(context).textTheme.bodyMedium)
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    }
    return Scaffold(
        appBar: barCustom.appBarCustomNoTabs(context, arguments['name'] ?? '', null),
        body: Center(child: Text('ไม่มีการแจ้งเตือน', style: Theme.of(context).textTheme.titleMedium) 
      ),
    );
  }
}
