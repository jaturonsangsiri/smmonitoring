import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

class App extends StatelessWidget {
  final bool theme;
  final String path;
  const App({super.key, required this.theme, required this.path});

  @override
  Widget build(BuildContext context) {
    context.read<ThemeBloc>().add(InitTheme(theme));

    // เรียกใช้เช็คขนาดหน้าจอเพื่อปรับ UI ตาม
    Responsive.init(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          navigatorKey: custom_route.Route.navigatorKey,
          scaffoldMessengerKey: custom_route.Route.scaffoldMessengerKey,
          initialRoute: path,
          routes: custom_route.Route.getAll(),
          // ไม่ให้แสดง banner debug สีแดง
          debugShowCheckedModeBanner: false,
          // ปรับให้แอปรองรับภาษาไทย
          locale: const Locale('th', 'TH'),
          // ปรับธีม
          themeMode: themeState.themeApp? ThemeMode.dark : ThemeMode.light, // ให้แอปใช้ธีม Dark Mode
          theme: ThemeData(
            // ธีม Light ที่คุณปรับแต่ง
            fontFamily: 'Anuphan',
            appBarTheme: AppBarTheme(backgroundColor: secColor),
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            canvasColor: Colors.white,
            textTheme: TextTheme(
              headlineLarge: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.black),
              labelLarge: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Anuphan',
            // ธีม Dark ที่คุณปรับแต่ง
            appBarTheme: AppBarTheme(backgroundColor: Color(0xFF2C2C2E).withValues(alpha: 0.7)),
            // สี DropDown
            canvasColor: boxColorDark,
            scaffoldBackgroundColor: fourColorDark,
            textTheme: TextTheme(
              headlineLarge: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white70),
              bodyLarge: TextStyle(color: Colors.white70),
              labelLarge: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white70),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
            // ตั้งค่าความสวยงาม TextFormFild
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: sixColor),
              ),
            ),
          ),
          supportedLocales: const [Locale('th', 'TH'), Locale('en', 'EN')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // ปรับให้การเลือกเวลาเป็น format 24 ชม.
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!, 
            );
          },
        );
      },
    );
  }
}
