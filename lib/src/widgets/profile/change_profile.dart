import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/widgets/icons_style.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  File? imagePicker;
  Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
  Api api = Api();

  void pickImage(ImageSource imageType, void Function(void Function()) setState) async {
    imagePicker = await systemwidgetcustom.pickImage(imageType);
    if (imagePicker != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, snapshot) {
        double imageSize = Responsive.isTablet ? 200 : 120;
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Stack(
              children: [
                // รูปโปรไฟล์
                SizedBox(
                  height: Responsive.isTablet ? 350 : 120,
                  width: Responsive.isTablet ? 250 : 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Responsive.isTablet ? 150 : 60),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.pic,
                      placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white70),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // ไอคอนกล้อง
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleIcon(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 25),
                    colorbg: primaryColor,
                    padding: 1,
                    function: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // ไม่ให้ปิด Dialog โดยการคลิกนอก Dialog
                        builder: (context) => BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
                          return Center(
                            child: Container(
                              height: Responsive.isTablet ? 430 : 330,
                              width: Responsive.isTablet ? 400 : 300,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(color: themeState.themeApp? fourColorDark : Colors.white, borderRadius: BorderRadius.circular(15)),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Column(
                                    children: [
                                      imagePicker != null? SizedBox(
                                        height: imageSize,
                                        width: imageSize,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(imageSize / 2),
                                          child: Image.file(
                                            imagePicker!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ) : SizedBox(
                                        height: imageSize,
                                        width: imageSize,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(imageSize / 2),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.pic,
                                            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white70),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      IconText(onTap:() => pickImage(ImageSource.gallery, setState), icon: Icons.photo, text: 'เลือกรูปจากแกลเลอรี', backgroundColor: secColorDark, color: Colors.white, size: 25, fontSize: 16),
                                      const SizedBox(height: 10),
                                      IconText(onTap: () => pickImage(ImageSource.camera, setState), icon: Icons.camera_alt, text: 'ถ่ายรูปใหม่', backgroundColor: secColorDark, color: Colors.white, size: 25, fontSize: 16),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(themeState.themeApp? fourColorDark : Colors.white),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.white, width: 1))),
                                              side: WidgetStateProperty.all<BorderSide>(BorderSide(color: const Color.fromRGBO(255,99,71,1)),
                                              ),
                                            ),
                                            onPressed: () {
                                              imagePicker = null;
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('ยกเลิก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: redColor),),
                                          ),
                                          const SizedBox(width: 20),
                                          OutlinedButton(
                                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(primaryColor), shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: primaryColor, width: 1)))),
                                            onPressed: () async {
                                              bool result = await api.uploadImage(imagePicker, snapshot.id);
                                              if(result) {
                                                if(context.mounted) {
                                                  context.read<UsersBloc>().add(SetUser());
                                                  Navigator.pop(context);
                                                }
                                                ShowSnackbar.snackbar(ContentType.success, "สำเร็จ", "แก้ไขรูปภาพสำเร็จ");
                                              } else {
                                                ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถแก้ไขรูปภาพได้");
                                              }
                                            },
                                            child: Text('ตกลง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        })
                      );
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
