import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // ---------- ประกาศตัวแปร ----------
  // key ของตัวกรอกข้อมูล
  final _formKey = GlobalKey<FormState>();
  // controllers form
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conFirmPasswordController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  // focus node
  FocusNode nameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode conFocus = FocusNode();
  FocusNode accNameFocus = FocusNode();
  // custom widget
  Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
  final Api api = Api();
  bool isShowPass = true;

  // ---------- ฟังก์ชั่นจำลองสมัครบัญชี ----------
  void register(BuildContext context) async {
    systemwidgetcustom.loadingWidget(context);

    if (_formKey.currentState!.validate()) {
      if (passwordController.text.isNotEmpty && conFirmPasswordController.text.isNotEmpty) {
        try {
          final response = await api.register(nameController.text, passwordController.text, accountNameController.text);
          if (response) {
            _unfocus();
            _formKey.currentState!.reset();
            if (context.mounted) {
              // ปิดการโหลดข้อมูล
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, custom_route.Route.login, (route) => false);
              ShowSnackbar.snackbar(ContentType.success, "สำเร็จ", "ลงทะเบียนสำเร็จ");
            }
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) Navigator.pop(context);
          }
        } catch (e) {
          // ปิดการโหลดข้อมูล
           if (context.mounted) Navigator.pop(context);
          setState(() {
            ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถลงทะเบียนได้");
          });
        }
      } else {
        // ปิดการโหลดข้อมูล
        Navigator.pop(context);
        // แสดงข้อความรหัสผ่านไม่ตรงกัน
        ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "รหัสผ่านไม่ตรงกัน");
      }
    }
  }

  // ------------- ฟังก์ชั่นกดแสดงรหัสผ่าน ------------
  void togglePassword() {
    setState(() {
      isShowPass = !isShowPass;
      // เช็คถ้ายังกดอยู่กับช่องใส่รหัสผ่านจะไม่ทำอะไร
      if (passFocus.hasPrimaryFocus) return;
      if (conFocus.hasPrimaryFocus) return;
      // ป้องกันการกดปุ่มก่อนเวลา
      passFocus.canRequestFocus = false;
      conFocus.canRequestFocus = false;
    });
  }

  // ---------- ฟังก์ชั่น unfocus ----------
  void _unfocus() {
    nameController.clear();
    passwordController.clear();
    nameController.clear();

    nameFocus.unfocus();
    passFocus.unfocus();
    accNameFocus.unfocus();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    conFirmPasswordController.dispose();
    accountNameController.dispose();
    nameFocus.dispose();
    passFocus.dispose();
    accNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          systemwidgetcustom.normalTextFormField(controller: nameController,hintText: 'ชื่อผู้ใช้',keyboardType: TextInputType.name, focus: nameFocus, hintColor: Colors.black),
          const SizedBox(height: 10,),
          TextFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'รหัสผ่าน',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: GestureDetector(
                onTap: togglePassword,
                child: isShowPass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              ),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: sixColor)),
            ),
            obscureText: isShowPass,
            controller: passwordController,
            focusNode: passFocus,
          ),
          const SizedBox(height: 10,),
          TextFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'ยืนยันรหัสผ่าน',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: GestureDetector(
                onTap: togglePassword,
                child: isShowPass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              ),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: sixColor)),
            ),
            obscureText: isShowPass,
            controller: conFirmPasswordController,
            focusNode: conFocus,
          ),
          const SizedBox(height: 10,),
          systemwidgetcustom.normalTextFormField(controller: accountNameController,hintText: 'ชื่อที่แสดง',keyboardType: TextInputType.name, focus: accNameFocus, hintColor: Colors.black),
          const SizedBox(height: 30,),
    
          // ปุ่มสมัครบัญชี
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              GestureDetector(
                onTap: () => register(context),
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(color: secColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Color.fromRGBO(181, 181, 181, 0.5), blurRadius: 4, offset: Offset(4, 8))]),
                  child: Center(child: Text('สมัครบัญชี', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}