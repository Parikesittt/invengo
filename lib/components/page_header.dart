import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontSize: 28, color: AppColor.primaryTextLight),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColor.primaryTextLightOpacity60),
      ),
      trailing: trailing,
    );
  }
}
