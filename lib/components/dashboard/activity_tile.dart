import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const ActivityTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Color(0xffe5e7eb)),
      ),
      tileColor: Colors.white,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 13.7, color: Color(0xff101828))),
      subtitle: Text(subtitle, style: TextStyle(color: Color(0x60101828))),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 14, color: Color(0xff101828))),
          Text(time, style: TextStyle(color: Color(0x60101828), fontSize: 12)),
        ],
      ),
    );
  }
}
