import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';

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
      title: Text(title, style: AppTextStyle.header(context)),
      subtitle: Text(subtitle, style: AppTextStyle.subHeader(context)),
      trailing: trailing,
    );
  }
}
