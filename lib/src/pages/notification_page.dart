import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/models/models.dart';
import 'package:smmonitoring/src/pages/notification_settings_page.dart';
import 'package:smmonitoring/src/widgets/notification/notification.dart';
import 'package:smmonitoring/src/widgets/notification/notification_legacy.dart';
import 'package:smmonitoring/src/widgets/tab_item.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int tabLength = 1;
  final List<TabItem> tab = [];
  final List<Widget> tabView = [];
  List newWards = [], legacyWards = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    BarCustom tabbarBottomAppbar = BarCustom();
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, userState) {
        switch (userState.role) {
          case "USER":
            tab.addAll([const TabItem(title: 'eTEMP/iTemS')]);
            tabView.addAll([const SizedBox(child: NotificationList())]);
            break;
          case "LEGACY_USER":
            tab.addAll([const TabItem(title: 'Line Notify')]);
            tabView.addAll([const SizedBox(child: NotificationLegacy())]);
            break;
          case "GUEST":
            tab.addAll([const TabItem(title: 'eTEMP/iTemS')]);
            tabView.addAll([const SizedBox(child: NotificationList())]);
            break;
          case "SUPER":
            tab.addAll([
              const TabItem(title: 'eTEMP/iTemS'),
              const TabItem(title: 'Line Notify'),
            ]);
            tabView.addAll([
              const SizedBox(child: NotificationList()),
              const SizedBox(child: NotificationLegacy()),
            ]);
            tabLength = 2;
            break;
          case "SERVICE":
            tab.addAll([
              const TabItem(title: 'eTEMP/iTemS'),
              const TabItem(title: 'Line Notify'),
            ]);
            tabView.addAll([
              const SizedBox(child: NotificationList()),
              const SizedBox(child: NotificationLegacy()),
            ]);
            tabLength = 2;
            break;
          default:
            final List<Ward> wards = [];
            for (var hospital in userState.hospital) {
              wards.addAll(hospital.ward!);
            }
            newWards = wards.where((ward) => ward.type == "NEW").toList();
            legacyWards = wards.where((ward) => ward.type == "LEGACY").toList();
            if (newWards.isNotEmpty && legacyWards.isNotEmpty) {
              tabLength = 2;
              tab.addAll([const TabItem(title: 'eTEMP/iTemS'), const TabItem(title: 'Line Notify')]);
              tabView.addAll([
                const SizedBox(child: NotificationList()),
                const SizedBox(child: NotificationLegacy()),
              ]);
            } else {
              if (newWards.isNotEmpty) {
                tab.addAll([const TabItem(title: 'eTEMP/iTemS')]);
                tabView.addAll([const SizedBox(child: NotificationList())]);
              } else {
                tab.addAll([const TabItem(title: 'Line Notify')]);
                tabView.addAll([const SizedBox(child: NotificationLegacy())]);
              }
            }
            break;
        }

        return DefaultTabController(
          length: tabLength,
          child: Scaffold(
            appBar: tabbarBottomAppbar.appBarCustom(
              context,
              'แจ้งเตือน',
              tab,
              [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationSettingsPage(newWard: newWards.length, legacyWard: legacyWards.length),
                        ),
                      ),
                  icon: Icon(Icons.settings, color: Colors.white, size: Responsive.isTablet ? 35 : 25),
                ),
                const SizedBox(width: 20),
              ],
            ),
            body: TabBarView(children: tabView),
          ),
        );
      },
    );
  }
}
