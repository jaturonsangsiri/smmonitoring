import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/widgets/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class BarCustom {
  PreferredSize tabbarBottomApp(List<TabItem> tabs) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40), 
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Container(
            height: 40,
            decoration: BoxDecoration(color: themeState.themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade100),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(color: themeState.themeApp? secColorDark : threeColor),
              labelColor: Colors.white,
              unselectedLabelColor: themeState.themeApp? Colors.white : const Color.fromARGB(255, 94, 94, 94),
              labelStyle: TextStyle(fontSize: Responsive.isTablet ? 20 : 16),
              tabs: tabs
            ),
          );
        },
      )
    );
  }

  AppBar appBarCustom(BuildContext context, String title, List<TabItem> tabs, List<Widget>? actions) {
    final themeState = context.watch<ThemeBloc>().state;
    return AppBar(
      toolbarHeight: Responsive.isTablet ? 150 : 60,
      centerTitle: true,
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white, size: Responsive.isTablet ? 35 : 25)),
      actions: actions,
      backgroundColor: themeState.themeApp ? fourColorDark : secColor,
      title: Text(title, style: TextStyle(fontSize: Responsive.isTablet ? 28 : 20, fontWeight: FontWeight.bold, color: Colors.white),),
      bottom: tabbarBottomApp(tabs),
    );
  }

  AppBar appBarCustomNoTabs(BuildContext context, String title, List<Widget>? actions) {
    final themeState = context.watch<ThemeBloc>().state;
    return AppBar(
      toolbarHeight: Responsive.isTablet ? 150 : 60,
      centerTitle: true,
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white, size: Responsive.isTablet ? 35 : 25)),
      actions: actions,
      backgroundColor: themeState.themeApp ? Color(0xFF2C2C2E).withValues(alpha: 0.7) : secColor,
      title: Text(title, style: TextStyle(fontSize: Responsive.isTablet ? 28 : 20, fontWeight: FontWeight.bold, color: Colors.white),),
    );
  }
}