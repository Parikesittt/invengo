import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.click,
    required this.buttonText,
    required this.height,
    required this.width,
    this.icon,
  });
  final void Function()? click;
  final String buttonText;
  final double height;
  final double width;
  final IconData? icon;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColor.primaryGradient,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.click,
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Icon(widget.icon, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
