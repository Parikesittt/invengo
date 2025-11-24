import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_color.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.click,
    required this.buttonText,
    required this.height,
    required this.width,
    this.icon,
    this.isLoading = false,
  });
  final void Function()? click;
  final String buttonText;
  final double height;
  final double width;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColor.primaryGradient),
                ),
              ),
            ),
            Container(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: isLoading ? null : click,
                          child: Text(
                            buttonText,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Icon(icon, color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
