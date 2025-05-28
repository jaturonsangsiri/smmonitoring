import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _InputFormState();
}

class _InputFormState extends State<LoginForm> {
  // ---------- ประกาศตัวแปร ----------
  // key ของตัวกรอกผู้ใช้และรหัสผ่าน
  final _formKey = GlobalKey<FormState>();
  
  // controllers form
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // user pass focus node
  FocusNode userFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  // ตัวเช็คตัวเปิดมองเห็นรหัสผ่าน
  bool isShowPass = true;
  // Widget System Custom
  final Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
  final Api api = Api();

  // ------------- ฟังก์ชั่นกดแสดงรหัสผ่าน ------------
  void togglePassword() {
    setState(() {
      isShowPass = !isShowPass;
      // เช็คถ้ายังกดอยู่กับช่องใส่รหัสผ่านจะไม่ทำอะไร
      if (passFocus.hasPrimaryFocus) return;
      // ป้องกันการกดปุ่มก่อนเวลา
      passFocus.canRequestFocus = false;
    });
  }

  // ------------- ฟังก์ชั่นกดปุ่มเข้าสู๋ระบบ ------------
  void login() async {
    _unfocus();
    systemwidgetcustom.loadingWidget(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "โปรดกรอกข้อมูลให้ครบถ้วน");
        Navigator.pop(context);
        return;
      }

      // เช็คชื่อผู้ใช้และรหัสผ่าน
      try {
        final user = await api.checkLogin(usernameController.text, passwordController.text);
        ShowSnackbar.snackbar(ContentType.success, "แจ้งเตือน", "ยินดีต้อนรับคุณ ${user.data!.name}");

        setState(() {
          usernameController.clear();
          passwordController.clear();

          // ปิดโหลดดิ้ง
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, custom_route.Route.home, (route) => false);
        });
      } on Exception catch (e) {
        setState(() {
          // ปิดโหลดดิ้ง
          Navigator.pop(context);
          ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", e.toString());
        });
      }
    }
  }

  // ------------- ยกเลิก focus ช่องกรอกข้อมูล -------------
  void _unfocus() {
    userFocus.unfocus();
    passFocus.unfocus();
  }

  // ------------- ฟังก์ชั่นเคลียร์คอนโทรเลอร์ -------------
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    userFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'บัญชีผู้ใช้',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: sixColor)),
            ),
            controller: usernameController,
            focusNode: userFocus,
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 30),
                      
          // ปุ่มเข้าสู่ระบบ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: login,
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: secColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Color.fromRGBO(181, 181, 181, 0.5), blurRadius: 4,offset: Offset(4, 8)),
                    ],
                  ),
                  child: Center(child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}