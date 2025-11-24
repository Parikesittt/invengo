import 'package:flutter/material.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Image.asset(
            'assets/images/logo_transparant.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        h(16),
        Text(
          title,
          style: TextStyle(color: AppColor.primaryTextLight, fontSize: 30),
        ),
        h(8),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColor.primaryTextLightOpacity60,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
