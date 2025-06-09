import 'dart:async';

import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/configs/url.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/widgets/home/subtitle_list.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class DeviceLists extends StatefulWidget {
  const DeviceLists({super.key});

  @override
  State<DeviceLists> createState() => _DeviceListsState();
}

class _DeviceListsState extends State<DeviceLists> {
  Timer? _timer;
  late String ward;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      context.read<DevicesBloc>().add(GetDevices(ward));
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<DevicesBloc, DevicesState>(
            builder: (context, state) {
              ward = state.wardId;
              return state.isLoading? Center(child: Text('กำลังโหลดข้อมูล',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: fourColor),)) : state.devices.isEmpty? Center(child: Text('ไม่มีข้อมูล',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: fourColor),)) : ListView.builder(
                padding: EdgeInsets.only(top: 0,bottom: 0),
                itemCount: state.devices.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, custom_route.Route.device, arguments: {'name': state.devices[i].name!, 'serial': state.devices[i].serial!}),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      //elevation: 8,
                      color: themeState.themeApp? boxColorDark : Colors.white,
                      shadowColor: Color.fromRGBO(181, 181, 181, 0.5),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(0),
                          width: Responsive.isTablet? 80 : 70,
                          height: Responsive.isTablet? 110 : 100,
                          decoration: BoxDecoration(color: fourColor, borderRadius: BorderRadius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: state.devices[i].positionPic ?? URL.DEFAULT_PIC,
                            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white70),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.fill,
                            height: 50,
                            scale: 0.7,
                          ),
                        ),
                        title: Text(state.devices[i].name ?? "", style: TextStyle(fontSize: Responsive.isTablet? 18 : 14, fontWeight: FontWeight.w700, color: themeState.themeApp? Colors.white : Colors.black)),
                        subtitle: SubtitleList(deviceInfo: state.devices[i]),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }, 
      )
    );
  }
}