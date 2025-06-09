import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/models.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/services/preference.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
  // ชื่อผู้ใช้
  String username = '';
  // ไอดีผู้ใช้
  String userID = '';
  // ตัวเช็คตัวเปิดมองเห็นรหัสผ่าน
  bool isShowPass = true;
  // ---------- Controllers ----------
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswrodController = TextEditingController();
  TextEditingController newPasswrodController = TextEditingController();
  TextEditingController confirmPasswrodController = TextEditingController();
  // ---------- Focus Nodes เอาไว้จัดการการโฟกัส ----------
  FocusNode nameFocusNode = FocusNode();
  FocusNode newPasswrodFocusNode = FocusNode();
  FocusNode oldPasswrodFocusNode = FocusNode();
  FocusNode confirmPasswrodNode = FocusNode();
  // ---------- Global Key ----------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Api api = Api();
  final configStorage = ConfigStorage();

  // ------------- ฟังก์ชั่นกดแสดงรหัสผ่าน ------------
  void togglePassword(FocusNode focusNode) {
    setState(() {
      isShowPass = !isShowPass;
      // เช็คถ้ายังกดอยู่กับช่องใส่รหัสผ่านจะไม่ทำอะไร
      if (focusNode.hasPrimaryFocus) return;
      // ป้องกันการกดปุ่มก่อนเวลา
      focusNode.canRequestFocus = false;
    });
  }

  // ฟังก์ชั่นเปลี่ยนชื่อผู้ใช้
  void changeDisplayname(BuildContext context) async {
    if (nameController.text != "") {
      UserData user = UserData(display: nameController.text);
      try {
        bool? response = await api.updateUser(userID, user);
        if (response && context.mounted) {
          if (context.mounted) {
            context.read<UsersBloc>().add(SetUser());
          }
          ShowSnackbar.snackbar(ContentType.success, "สำเร็จ", "แก้ไขชื่อที่แสดงสำเร็จ");
        }
      } catch (e) {
        if (kDebugMode) print(e.toString());
        if (context.mounted) {
          ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถแก้ไขชื่อที่แสดงได้");
        }
      }
    } else {
      if (context.mounted) ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "โปรดกรอกชื่อที่แสดง");
    }
  }

  // ฟังก์ชั่นเปลี่ยนรหัสผ่าน
  void changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (newPasswrodController.text != confirmPasswrodController.text) {
          if (context.mounted) {
            ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "รหัสผ่านไม่ตรงกัน");
          }
          return;
        }
        ChangePassword changePassword = ChangePassword(oldPassword: oldPasswrodController.text, password: newPasswrodController.text);
        final response = await api.changPass(username, changePassword);
        if (response && context.mounted) {
          unfocus();
          _formKey.currentState!.reset();
          ShowSnackbar.snackbar(ContentType.success, "สำเร็จ", "แก้ไขรหัสผ่านสำเร็จ");
          systemwidgetcustom.loadingWidget(context);

          // ออกจากระบบไปหน้าเข้าสู่ระบบ
          await configStorage.clearTokens();
          if (context.mounted) {
            context.read<UsersBloc>().add(RemoveUser());
            context.read<DevicesBloc>().add(ClearDevices());
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(context, custom_route.Route.login, (route) => false);
          }
        }
      } catch (e) {
        unfocus();
        if (kDebugMode) print(e.toString());
        if (context.mounted) {
          ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถแก้ไขรหัสผ่านได้");
        }
      }
    }
  }

  // // ฟังก์ชั่นสุ่มตำแหน่งวงกลมสีน้ำเงินในแถบด้านบน
  // void getPo(double w) {
  //   positionedList = [];
  //   for (int i = 0; i < 5; i++)
  //   {
  //     double top = Random().nextInt(90).toDouble();  // จำกัดไว้ไม่เกิน 120 px
  //     double left = Random().nextInt((w - 60).toInt()).toDouble(); // ขอบซ้าย 
  //     double width = 40 + Random().nextInt(20).toDouble();
  //     double height = 40 + Random().nextInt(20).toDouble();
  //     positionedList.add([top, left, width, height]);
  //     print("จุดที่ ${i+1}: $top, $left, $width, $height");
  //   }
  // }

  // ฟังก์ชั่น unfocus
  void unfocus() {
    nameFocusNode.unfocus();
    oldPasswrodFocusNode.unfocus();
    newPasswrodFocusNode.unfocus();
    confirmPasswrodNode.unfocus();

    nameController.clear();
    oldPasswrodController.clear();
    newPasswrodController.clear();
    confirmPasswrodController.clear();
  }

//  @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       double w = MediaQuery.of(context).size.width;
//       //getPo(w);
//       setState(() {});
//     });
//   }

  // ปิดตัวคอนโทลเลอร์และโฟกัสโนดเมื่อไม่ใช้งาน
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    oldPasswrodController.dispose();
    newPasswrodController.dispose();
    confirmPasswrodController.dispose();
    nameFocusNode.dispose();
    newPasswrodFocusNode.dispose();
    oldPasswrodFocusNode.dispose();
    confirmPasswrodNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, snapshot) {
        nameController.text = snapshot.display;
        username = snapshot.username;
        userID = snapshot.id;
        return Form(
          key: _formKey,
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('เปลี่ยนธีมแอป', style: TextStyle(fontSize: Responsive.isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
                          CustomSwitch(value: state.themeApp, onChanged: (value) => context.read<ThemeBloc>().add(SetTheme()), inactiveColor: Colors.grey.shade400, thumbColor: Colors.white, activeColor: secColor),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          systemwidgetcustom.showDialogConfirm(context, 'ลบบัญชี', 'ท่านต้องการลบบัญชีหรือไม่?', () async {
                            Navigator.pop(context);
                            systemwidgetcustom.loadingWidget(context);

                            // ลบบัญชีและกลับไปหน้าเข้าสู่ระบบ
                            try {
                              await api.deleteUser(snapshot.id);
                              await configStorage.clearTokens();
                              if (context.mounted) {
                                context.read<DevicesBloc>().add(ClearDevices());
                                context.read<UsersBloc>().add(RemoveUser());
                                Navigator.of(context).pop();
                                Navigator.pushNamedAndRemoveUntil(context, custom_route.Route.login, (route) => false);
                              }
                            } on Exception catch (e) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              if (kDebugMode) print(e.toString());
                              if (context.mounted) {
                                ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถลบบัญชีได้");
                              }
                            }
                          }, primaryColor, redColor);
                        },
                        icon: const Icon(Icons.save, color: Colors.white, size: 30),
                        label: const Text('ลบบัญชีผู้ใช้',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.themeApp ? redColorDark : redColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Text('ชื่อผู้ใช้', style: TextStyle(fontSize: Responsive.isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
                  systemwidgetcustom.normalTextFormField(hintText: 'ชื่อผู้ใช้', controller: nameController, keyboardType: TextInputType.text, focus: nameFocusNode, hintColor: state.themeApp? Colors.white70 : Colors.black),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: () => changeDisplayname(context), style: ElevatedButton.styleFrom(backgroundColor: secColor), child: const Text('บันทึก',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),),
                  const SizedBox(height: 25,),
                  Text('รหัสผ่านเก่า', style: TextStyle(fontSize: Responsive.isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
                  buildTextFormField('รหัสผ่านเก่า', oldPasswrodController, oldPasswrodFocusNode, state.themeApp),
                  const SizedBox(height: 10,),
                  Text('รหัสผ่านใหม่', style: TextStyle(fontSize: Responsive.isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
                  buildTextFormField('รหัสผ่านใหม่', newPasswrodController, newPasswrodFocusNode, state.themeApp),
                  const SizedBox(height: 10,),
                  Text('ยืนยันรหัสผ่านใหม่', style: TextStyle(fontSize: Responsive.isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
                  buildTextFormField('ยืนยันรหัสผ่านใหม่', confirmPasswrodController, confirmPasswrodNode, state.themeApp),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: () => changePassword(context), style: ElevatedButton.styleFrom(backgroundColor: secColor), child: const Text('บันทึก',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),),
                ],
              );
            },  
          )
        );
      },
    );
  }

  Widget buildTextFormField(String hintText, TextEditingController controller, FocusNode focusNode, bool themeApp) {
    return TextFormField(
      style: TextStyle(color: themeApp? Colors.white70 : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: themeApp? Colors.white70 : Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        suffixIcon: GestureDetector(onTap: () => togglePassword(confirmPasswrodNode), child: isShowPass ? Icon(Icons.visibility, color: themeApp? Colors.white70 : Colors.black) : Icon(Icons.visibility_off, color: themeApp? Colors.white70 : Colors.black)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: sixColor)),
      ),
      obscureText: isShowPass,
      controller: controller,
      focusNode: focusNode,
    );
  }
}