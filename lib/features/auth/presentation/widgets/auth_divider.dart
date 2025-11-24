import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_color.dart';

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(child: Divider(color: AppColor.dividerLightOpacity20)),
        Text("Or $text with", style: TextStyle(color: AppColor.primaryTextLightOpacity60)),
        Expanded(child: Divider(color: AppColor.dividerLightOpacity20)),
      ],
    );
  }
}
