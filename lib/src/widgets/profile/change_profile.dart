import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/widgets/icons_style.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeProfile extends StatelessWidget {
  const ChangeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, snapshot) {
        return Align(  
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Stack(
              children: [
                // รูปโปรไฟล์
                systemwidgetcustom.circleImageButton(snapshot.pic,60,100,() {},60),
                // ไอคอนกล้อง
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleIcon(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 25),
                    colorbg: primaryColor,
                    padding: 1,
                    function: () {
                      //unfocus();
                      //showDialog(context: context, builder: (context) => AlertDialog(title: Text('เปิดกล้อง'),content: Text('กำลังเปิดกล้อง'),actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก',style: TextStyle(color: Colors.red),)),TextButton(onPressed: ()=>Navigator.pop(context), child: Text('ตกลง',style: TextStyle(color: secColor),))],));
                    },
                  ),
                ),
              ],
            ),
          ),  
        );
      },
    );
  }
}