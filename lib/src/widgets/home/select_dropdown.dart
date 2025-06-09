import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/hospitals.dart';
import 'package:smmonitoring/src/widgets/search_dropdown.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDropdown extends StatefulWidget {
  const SelectDropdown({super.key});

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  List<Ward> wards = [];
  String? selectedhospitalId;
  String? selectedWardId;

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(SetHospital());
  }

  // ดึงข้อมูลอุปกรณ์โรงพยาบาลและแผนก
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if(state.isLoading) {
          return Center(child: Text('กำลังโหลดข้อมูล',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: fourColor),));
        }
        if(state.hospital.isEmpty) {
          return Center(child: Text('ไม่มีข้อมูล',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: fourColor),),);
        }
        if(wards.isEmpty) {
          wards = state.hospital.first.ward!;
          Ward? ward = wards.firstWhere((u) => u.id == wards.first.id!);
          selectedhospitalId = state.hospital.first.id;
          selectedWardId = wards.first.id;
          context.read<DevicesBloc>().add(SetHospitalData(state.hospital.first.id!, state.hospital.first.ward!.first.id!, ward.type!));
          context.read<DevicesBloc>().add(GetDevices(state.hospital.first.ward!.first.id!));
        }
        return  BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            List<Widget> widget = [
              CustomSearchDropdown<HospitalData>(
                items: state.hospital,
                selectedItem: selectedhospitalId != null? state.hospital.firstWhere((h) => h.id == selectedhospitalId) : state.hospital.first,
                labelText: 'โรงพยาบาล',
                width: Responsive.isTablet ? Responsive.width * 0.48 : Responsive.width * 0.95,
                menuHeight: Responsive.height * 0.6,
                backgroundColor: themeState.themeApp ? boxColorDark : Colors.white,
                textColor: themeState.themeApp ? Colors.white : Colors.black,
                textStyle: TextStyle(fontSize: Responsive.isTablet ? 18 : 14, color: themeState.themeApp ? Colors.white : Colors.black),
                labelStyle: TextStyle(fontSize: Responsive.isTablet ? 20 : 14, color: themeState.themeApp ? Colors.white : Colors.black),
                getDisplayText: (hospital) => hospital!.hosName ?? '',
                getValue: (hospital) => hospital.id ?? '',
                onChanged: (hospital) {
                  if (hospital != null && hospital.ward != null && hospital.ward!.isNotEmpty) {
                    final wardVal = hospital.ward!.first.id!;
                    final wardValType = hospital.ward!.first.type!;
                    
                    // อัปเดต state ก่อน
                    context.read<DevicesBloc>().add(SetHospitalData(hospital.id!, wardVal, wardValType));
                    
                    // เรียก API
                    if (wardValType == "NEW") {
                      context.read<DevicesBloc>().add(GetDevices(wardVal));
                    } else {
                      context.read<DevicesBloc>().add(GetLegacyDevices(wardVal));
                    }
                    
                    // อัปเดต local state
                    setState(() {
                      wards = hospital.ward!;
                      selectedhospitalId = hospital.id;
                      selectedWardId = wardVal; // อัปเดตค่า selectedWardId ด้วย
                    });
                  }
                },
              ),
              CustomSearchDropdown<Ward>(
                items: wards,
                selectedItem: selectedWardId != null? wards.firstWhere((w) => w.id == selectedWardId) : wards.first,
                labelText: 'แผนก',
                width: Responsive.isTablet ? Responsive.width * 0.45 : Responsive.width * 0.95,
                menuHeight: Responsive.height * 0.6,
                backgroundColor: themeState.themeApp ? boxColorDark : Colors.white,
                textColor: themeState.themeApp ? Colors.white : Colors.black,
                textStyle: TextStyle(fontSize: Responsive.isTablet ? 18 : 14, color: themeState.themeApp ? Colors.white : Colors.black),
                labelStyle: TextStyle(fontSize: Responsive.isTablet ? 20 : 14, color: themeState.themeApp ? Colors.white : Colors.black),
                getDisplayText: (ward) => ward!.wardName ?? '',
                getValue: (ward) => ward.id ?? '',
                onChanged: (ward) {
                  if (ward != null) {
                    // ใช้ hospital ID ที่เลือกจริงแทนที่จะใช้ .first
                    final selectedHospitalId = state.hospitalSelected;
                    
                    context.read<DevicesBloc>().add(SetHospitalData(selectedHospitalId, ward.id!, ward.type!));
                    
                    if (ward.type == "NEW") {
                      context.read<DevicesBloc>().add(GetDevices(ward.id!));
                    } else {
                      context.read<DevicesBloc>().add(GetLegacyDevices(ward.id!));
                    }
                    
                    // อัปเดต selectedWardId
                    setState(() {
                      selectedWardId = ward.id;
                    });
                  }
                },
              ),
            ];
            return Center(
              child: Responsive.isTablet ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget,
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget,
              ),
            );
          }, 
        );
      },
    );
  }
}