import 'package:flutter/material.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0x20364153)),
          ),
        ),
        child: Row(
          spacing: 16,
          children: [
            Image.asset(image, color: Color(0xff101828), width: 20),
            Text(buttonText, style: TextStyle(color: Color(0xff101828))),
          ],
        ),
      ),
    );
  }
}
