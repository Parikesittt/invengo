import 'package:flutter/material.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_text_style.dart';

class ButtonLogo extends StatelessWidget {
  const ButtonLogo({
    super.key,
    this.onTap,
    this.gradient,
    this.icon,
    this.iconColor,
    this.iconSize,
    required this.textButton,
    this.bgColor,
    this.isLoading = false,
  });

  final void Function()? onTap;
  final Gradient? gradient;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final String textButton;
  final Color? bgColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: gradient,
          color: bgColor,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: iconSize),
                  w(8),
                  Text(textButton, style: AppTextStyle.button(context)),
                ],
              ),
      ),
    );
  }
}
