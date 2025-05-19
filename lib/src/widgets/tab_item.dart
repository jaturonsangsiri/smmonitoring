import 'package:flutter/material.dart';

// Widget ของแท็บที่แสดงในแอปพลิเคชั่น
// ใช้สำหรับแสดงแท็บที่มีข้อมูลต่างๆ เช่น สถานะอุปกรณ์, การตั้งค่า, ข้อมูลผู้ใช้
class TabItem extends StatelessWidget {
  final String title;
  final int? count;
  const TabItem({super.key, required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, overflow: TextOverflow.ellipsis),
          count != null? Container(
            margin: const EdgeInsetsDirectional.only(start: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
            child: Center(child: Text(count! > 9 ? '9+' : count.toString(), style: TextStyle(color: Colors.black54))),
          ) : const SizedBox(width: 0, height: 0,),
        ],
      ),
    );
  }
}