import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/devices.dart';
import 'package:smmonitoring/src/widgets/probe_setting/notification_setting.dart';
import 'package:smmonitoring/src/widgets/probe_setting/report_setting.dart';
import 'package:smmonitoring/src/widgets/tab_item.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProbeSetting extends StatelessWidget {
  final List<Probe> probes;
  const ProbeSetting({super.key, required this.probes});

  @override
  Widget build(BuildContext context) {
    BarCustom tabbarBottomAppbar = BarCustom();
    List<TabItem> tabs = [];
    List<Widget> tabview = [];

    for (var probe in probes) {
      tabs.add(TabItem(title: 'โพรบ ${probe.channel}'));
      tabview.add(Column(
        children: [
          // เนื้อหาการตั้งค่า
          Expanded(
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return Container(
                  color: themeState.themeApp? fourColorDark : Colors.white,
                  child: ListView(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    children: [
                      NotificationSetting(probe: probe),
                      ReportSetting(probe: probe),
                    ],
                  ),
                );
              },
            )
          ),
        ],
      )
     );
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: tabbarBottomAppbar.appBarCustom(context, 'ตั้งค่าโพรบ', tabs, null),
        body: TabBarView(
          children: tabview,
        ),
      ),
    );
  }
}