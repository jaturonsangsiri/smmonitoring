import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/hospitals.dart';
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
        if(state.hospital.isEmpty) {
          return Center(child: Text('ไม่มีข้อมูล',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: fourColor),),);
        }

        if(wards.isEmpty) {
          wards = state.hospital.first.ward!;
          Ward? ward = wards.firstWhere((u) => u.id == wards.first.id!);
          context.read<DevicesBloc>().add(SetHospitalData(state.hospital.first.id!, state.hospital.first.ward!.first.id!, ward.type!));
          context.read<DevicesBloc>().add(GetDevices(state.hospital.first.ward!.first.id!));
        }
        return  BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  DropdownMenuTheme(
                    data: DropdownMenuThemeData(menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(themeState.themeApp? boxColorDark :  Colors.white),)),
                    child: DropdownMenu<String>(
                      initialSelection: state.hospital.first.id, 
                      trailingIcon: Icon(Icons.arrow_drop_down_outlined, color: themeState.themeApp? Colors.white : Colors.black,),
                      width: Responsive.width * 0.95,
                      menuHeight: Responsive.height * 0.6,
                      textStyle: TextStyle(color: themeState.themeApp? Colors.white : Colors.black),
                      dropdownMenuEntries: state.hospital.map((hos) {
                        return DropdownMenuEntry<String>(
                          value: hos.id!,
                          label: hos.hosName!,
                          labelWidget: Text(hos.hosName!, style: TextStyle(color: themeState.themeApp? Colors.white : Colors.black),),
                        ); 
                      }).toList(),
                      onSelected: (value) {
                        final wardVal = state.hospital.firstWhere((e) => e.id == value).ward!.first.id!;
                        final wardValType = state.hospital.firstWhere((e) => e.id == value).ward!.first.type!;
                        context.read<DevicesBloc>().add(SetHospitalData(value!, wardVal, wardValType));
                        if (wardValType == "NEW") {
                          context.read<DevicesBloc>().add(GetDevices(wardVal));
                        } else {
                          context.read<DevicesBloc>().add(GetLegacyDevices(wardVal));
                        }
                        setState(() => wards = state.hospital.firstWhere((e) => e.id == value).ward!);
                      },
                      label: Text('โรงพยาบาล', style: TextStyle(fontSize: Responsive.isTablet? 20 : 16, fontWeight: FontWeight.w700, color: themeState.themeApp? Colors.white : Colors.black),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  DropdownMenuTheme(
                    data: DropdownMenuThemeData(menuStyle: MenuStyle(backgroundColor: WidgetStateProperty.all(themeState.themeApp? boxColorDark :  Colors.white),)),
                    child: DropdownMenu<String>(
                      initialSelection: wards.first.id,
                      trailingIcon: Icon(Icons.arrow_drop_down_outlined, color: themeState.themeApp? Colors.white : Colors.black,),
                      width: Responsive.width * 0.95,
                      menuHeight: Responsive.height * 0.6,
                      textStyle: TextStyle(color: themeState.themeApp? Colors.white : Colors.black),
                      dropdownMenuEntries: wards.map((Ward ward) {
                        return DropdownMenuEntry<String>(
                          value: ward.id!,
                          label: ward.wardName!,
                          labelWidget: Text(ward.wardName!, style: TextStyle(color: themeState.themeApp? Colors.white : Colors.black),),
                        ); 
                      }).toList(),
                      onSelected: (value) {
                        Ward? ward = wards.firstWhere((u) => u.id == value);
                        context.read<DevicesBloc>().add(SetHospitalData(state.hospital.first.id!, value!, ward.type!));
                        if (ward.type == "NEW") {
                          context.read<DevicesBloc>().add(GetDevices(value));
                        } else {
                          context.read<DevicesBloc>().add(GetLegacyDevices(value));
                        }
                      },
                      label: Text('แผนก', style: TextStyle(fontSize: Responsive.isTablet? 20 : 16, fontWeight: FontWeight.w700, color: themeState.themeApp? Colors.white : Colors.black),),
                    ),
                  ),
                ],
              ),
            );
          }, 
        );
      },
    );
  }
}