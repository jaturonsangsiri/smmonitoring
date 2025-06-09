import 'package:smmonitoring/src/constants/contants.dart';
import 'package:flutter/material.dart';

// ไอคอนแบบมีวงกลม
// ใช้เป็นไอคอนมีวงลมด้านหลัง มีสีของไอคอน สีวงกลมหลังไอคอน ไอคอนอะไร ขนาดไอคอน
class CircleIcon extends StatelessWidget {
  final Color? colorbg;
  final Widget? icon;
  final Function()? function;
  final double padding;

  const CircleIcon({
    required this.icon,
    required this.colorbg,
    required this.function,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          onPressed: function,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(CircleBorder()),
            padding: WidgetStateProperty.all(EdgeInsets.all(padding)),
            backgroundColor: WidgetStateProperty.all(colorbg), // <-- Button color
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed)) {
                return threeColor; // <-- Splash color
              }
              return null;
            }),
          ),
          child: icon!
        ),
      ],
    );
  }
}

// ไอคอนแบบธรรมดา มีไอคอนและตัวหนังสือ
class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;
  final double size;
  final double fontSize;
  final Function() onTap;
  const IconText({super.key, required this.icon, required this.text, required this.backgroundColor, required this.color, required this.size, required this.fontSize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(icon, color: color,size: size,),
            const SizedBox(width: 20),
            Text(text, style: TextStyle(color: color, fontSize: fontSize),),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}