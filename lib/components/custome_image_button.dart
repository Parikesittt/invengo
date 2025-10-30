import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.image,
    required this.buttonText,
    this.onPressed,
  });
  final String image;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColor.borderLight),
          ),
        ),
        child: Row(
          spacing: 16,
          children: [
            Image.asset(image, color: AppColor.primaryTextLight, width: 20),
            Text(
              buttonText,
              style: TextStyle(color: AppColor.primaryTextLight),
            ),
          ],
        ),
      ),
    );
  }
}
