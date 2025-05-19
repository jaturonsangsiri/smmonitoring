import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
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
          body: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: Responsive.height * 0.40,
                  width: Responsive.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [secColor,  state.themeApp? fourColorDark :  fiveColor],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 70, left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('เข้าสู่ระบบ', style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: 20),
                        Text('กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
              ),

              // กล่องฟอร์ม (เข้าสู่ระบบหรือสมัครบัญชี)
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(25),
                  height: 280,
                  width: Responsive.width * 0.85,
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
                  child: LoginForm(),
                ),
              ),

              // ปุ่มสร้างบัญชี
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 80),
                  width: Responsive.width,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ยังไม่มีบัญชี?', style: Responsive.isTablet? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                            child: Text(' สร้างบัญชี', style: TextStyle(fontSize: Responsive.isTablet? 16 : 14, color: sixColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Version: 1.1.0', style: Responsive.isTablet? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.labelLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
