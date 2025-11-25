import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_text_style.dart';

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
    final theme = Theme.of(context);
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      tileColor: theme.colorScheme.surface,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: AppTextStyle.cardTitle(context)),
      subtitle: Text(subtitle, style: AppTextStyle.sectionSubtitle(context)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AppTextStyle.cardTitle(context)),
          Text(time, style: AppTextStyle.label(context)),
        ],
      ),
    );
  }
}
