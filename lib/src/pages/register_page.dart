import 'dart:math' as math;

import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/configs/version.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/widgets/register/input.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: Responsive.height * 0.22,
                            width: Responsive.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [secColor, state.themeApp? fourColorDark : fiveColor],
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 70, left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('สมัครบัญชีของท่าน', style: Theme.of(context).textTheme.headlineLarge),
                                  const SizedBox(height: 20),
                                  Text('กรุณาสมัครบัญชีของท่านเพื่อใช้บริการภายแอป', style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ),
                      
                          Container(
                            padding: const EdgeInsets.all(25),
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            height: 410,
                            width: math.min(400, Responsive.width * 0.9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: state.themeApp? [] : [
                                BoxShadow(
                                  color: Color.fromRGBO(181, 181, 181, 0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 8), // Shadow position
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(181, 181, 181, 0.5),
                                  blurRadius: 2,
                                  offset: Offset(-4, 8), // Shadow position
                                ),
                              ],
                            ),
                            child: RegisterForm(),
                          ),
                      
                          Spacer(),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('มีบัญชีอยู่แล้ว?', style: Responsive.isTablet? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(' เข้าสู่ระบบ',style: TextStyle(color: sixColor,fontSize: Responsive.isTablet ? 16 : 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Version: ${Versions.version}', style: Responsive.isTablet? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
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
