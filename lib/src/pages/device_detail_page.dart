import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/pages/probe_setting.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/widgets/device_widget.dart';
import 'package:smmonitoring/src/widgets/tab_item.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DevicedetailPage extends StatelessWidget {
  const DevicedetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    BarCustom tabbarBottomAppbar = BarCustom();
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final api = Api();
    List<TabItem> tabs = [];
    List<Widget> tabview = [];
    BarCustom barCustom = BarCustom();
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, users) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return FutureBuilder(
              future: api.getDeviceById(arguments['serial']),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถโหลดข้อมูลได้");
                  Navigator.pop(context);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    appBar: barCustom.appBarCustomNoTabs(context, arguments['name'], users.role == "USER" ? [] : [ Icon(Icons.settings, color: Colors.white, size: Responsive.isTablet ? 35 : 25), const SizedBox(width: 20) ]),
                    body: const Center(child: Text('กำลังโหลด')),
                  );
                }
                for (var probe in snapshot.data!.probe!) {
                  tabs.add(TabItem(title: 'โพรบ ${probe.channel}'));
                  tabview.add(DeviceDetailWidget(data: probe, devSerial: arguments['serial'], probe: probe.channel!));
                }
                return DefaultTabController(
                  length: tabs.length,
                  child: Scaffold(
                    appBar: tabbarBottomAppbar.appBarCustom(context, arguments['name'], tabs, users.role == "USER" ? [] : [
                        IconButton(
                          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ProbeSetting(probes: snapshot.data!.probe!))),
                          icon: Icon(Icons.settings, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    body: TabBarView(children: tabview),
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}
