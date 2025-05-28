import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Systemwidgetcustom {
  // UI โหลดข้อมูล
  Future loadingWidget(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5), // พื้นหลังโปร่งใส
      builder: (context) {
        return Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 6.0),
          ),
        );
      },
    );
  }

  // แสดง Dialog ถามผู้ใช้มีตอบ ใช่หรือไม่
  Future showDialogConfirm(BuildContext context, String title, String? content, Function onConfirm, Color buttonColor, Color bnColortwo) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // ไม่ให้ปิด Dialog โดยการคลิกนอก Dialog
      builder: (context) {
        return Center(
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return Container(
                height: 230,
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: themeState.themeApp ? boxColorDark : Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 170, 168, 168), decoration: TextDecoration.none)),
                    const SizedBox(height: 30),
                    Text(content!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: themeState.themeApp ? Colors.white70 : Colors.black,decoration: TextDecoration.none)),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(themeState.themeApp ? boxColorDark : Colors.white),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: themeState.themeApp ? boxColorDark : Colors.white, width: 1))),
                            side: WidgetStateProperty.all<BorderSide>(BorderSide(color: buttonColor)),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('ยกเลิก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: buttonColor)),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(bnColortwo,), shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: bnColortwo, width: 1)))),
                          onPressed: () => onConfirm(),
                          child: Text('ตกลง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ปุ่มสีพื้นหลังเต็มทั้งปุ่ม
  Widget fullButon(Color bgColor, Color textColor, String text) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }

  // ตัวหนังสือที่มีไอคอนอยู่ด้านหน้า
  Widget textWithIcon(IconData icon, String text, Color color, double size) {
    return Row(
      children: [
        Icon(icon, color: color, size: size * 1.5),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: size, color: color)),
      ],
    );
  }

  // Widget TextFormField
  Widget normalTextFormField({required String hintText, required TextEditingController controller, required TextInputType keyboardType, required FocusNode focus, required Color hintColor}) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return TextFormField(
          style: TextStyle(color: themeState.themeApp? Colors.white70 : Colors.black),
          focusNode: focus,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: sixColor)),
          ),
        );
      },
    );
  }

  // รูปโปรไฟล์ วงกลมมีรูปภาพอยู่ด้านใน
  Widget circleImageButton(String picPath, double size, double picHeight, GestureTapCallback onTap, double radius,) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox.fromSize(
          size: Size.fromRadius(size),
          child: CachedNetworkImage(
            imageUrl: picPath,
            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white70),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
            height: 50,
            scale: 0.7,
          ),
        ),
      ),
    );
  }

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source, maxHeight: 500, maxWidth: 500, imageQuality: 70);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}

// สวิทซ์เลื่อนสร้างขึ้นเอง
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color? thumbColor;
  final double width;
  final double height;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.deepOrange,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.width = 60,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: value ? activeColor : inactiveColor),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 250),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: height - 6,
                height: height - 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: thumbColor, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
