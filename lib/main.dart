// import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:smmonitoring/firebase_options.dart';
// import 'package:smmonitoring/src/app.dart';
// import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
// import 'package:smmonitoring/src/bloc/notification/notification_bloc.dart';
// import 'package:smmonitoring/src/bloc/probe/probe_setting_bloc.dart';
// import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
// import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
// import 'package:smmonitoring/src/services/firebase_api.dart';
// import 'package:smmonitoring/src/services/network.dart';
// import 'package:smmonitoring/src/services/preference.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   if (kDebugMode) {
//     print("BG Notification Title: ${message.notification?.title}");
//     print("BG Notification Body: ${message.notification?.body}");
//     print("BG Notification Data: ${message.data}");
//   }
// }

// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   // จัดการเกี่ยวกับหน้า Splash Screen (หน้าโหลดก่อนเข้าแอป)
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
//   String route = "/";
//   if (connectivityResult.contains(ConnectivityResult.none)) {
//     route = "/error";
//   } else {
//     HttpOverrides.global = PostHttpOverrides();
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     final firebaseApi = FirebaseApi();
//     final configStorage = ConfigStorage();
//     await firebaseApi.initNotifications();
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     String? token = await configStorage.getAccessToken();
//     if (token == null) {
//       await configStorage.clearTokens();
//       route = "/login";
//     }
//   }

//   // ทำการโหลดข้อมูลที่ต้องการใช้งานก่อนเข้าแอป
//   final configStorage = ConfigStorage();
//   bool theme = await configStorage.getTheme() ?? false;

//   // ดึง Bloc ทั้งหมดมา
//   // Bloc ตัวตั้งค่าโพรบ
//   final probeBloc = BlocProvider<ProbeSettingBloc>(create: (context) => ProbeSettingBloc());
//   final devicesBloc = BlocProvider<DevicesBloc>(create: (context) => DevicesBloc());
//   final userBloc = BlocProvider<UsersBloc>(create: (context) => UsersBloc());
//   final notificationBloc = BlocProvider(create: (context) => NotificationBloc());
//   final themeBloc = BlocProvider(create: (context) => ThemeBloc());

//   FlutterNativeSplash.remove();
//   runApp(
//     MultiBlocProvider(
//       providers: [probeBloc, devicesBloc, userBloc, notificationBloc, themeBloc], 
//       child: App(theme: theme, path: route),
//     ),
//   );
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searchable Dropdown Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchableDropdownDemo(),
    );
  }
}

class SearchableDropdownDemo extends StatefulWidget {
  @override
  _SearchableDropdownDemoState createState() => _SearchableDropdownDemoState();
}

class _SearchableDropdownDemoState extends State<SearchableDropdownDemo> {
  // Sample data
  final List<String> countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Australia',
    'Japan',
    'China',
    'India',
    'Brazil',
    'Mexico',
    'Russia',
    'South Korea',
    'ขนมปัง',
    'ไขไก่'
  ];

  String? selectedhospital;
  String? selectedhospitalCustom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searchable Dropdown Examples'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchDropdown(
              items: countries,
              selectedItem: selectedhospitalCustom,
              onChanged: (value) {
                setState(() {
                  selectedhospitalCustom = value;
                });
              },
              hintText: 'Select a hospital',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final String hintText;

  const CustomSearchDropdown({
    Key? key,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.hintText = 'Select an item',
  }) : super(key: key);

  @override
  _CustomSearchDropdownState createState() => _CustomSearchDropdownState();
}

class _CustomSearchDropdownState extends State<CustomSearchDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
    _searchController.clear();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          widget.onChanged?.call(item);
                          _closeDropdown();
                        },
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.selectedItem ?? widget.hintText, style: TextStyle(color: widget.selectedItem != null ? Colors.black : Colors.grey[600])),
              Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}