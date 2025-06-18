import 'dart:math' as math;

import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/configs/version.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/pages/register_page.dart';
import 'package:smmonitoring/src/widgets/login/input.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // ส่วนหัว
                          Container(
                            height: Responsive.height * 0.30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [secColor, state.themeApp ? fourColorDark : fiveColor],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 70, left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('เข้าสู่ระบบ', style:Theme.of(context).textTheme.headlineLarge),
                                  const SizedBox(height: 20),
                                  Text('กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ', style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ),

                          // ฟอร์ม
                          Container(
                            padding: const EdgeInsets.all(25),
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            width: math.min(400, Responsive.width * 0.9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: state.themeApp 
                                ? [] 
                                : [
                                    BoxShadow(
                                      color: Color.fromRGBO(181, 181, 181, 0.5), 
                                      blurRadius: 4, 
                                      offset: Offset(4, 8)
                                    ), 
                                    BoxShadow(
                                      color: Color.fromRGBO(181, 181, 181, 0.5), 
                                      blurRadius: 2, 
                                      offset: Offset(-4, 8)
                                    )
                                  ],
                            ),
                            child: const LoginForm(),
                          ),

                          const Spacer(), // ดัน footer ไปด้านล่าง
                          // ลิงก์ + เวอร์ชัน
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ยังไม่มีบัญชี?', style: Responsive.isTablet ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
                                  GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                                    child: Text(' สร้างบัญชี', style: TextStyle(fontSize: Responsive.isTablet ? 16 : 14, color: sixColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Version: ${Versions.version}', style: Responsive.isTablet ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
