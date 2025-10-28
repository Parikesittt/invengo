import 'package:flutter/material.dart';

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
                    colors: [Color(0xff8C5CF5), Color(0xffEB489A)],
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
    // SizedBox(
    //   width: widget.width,
    //   height: widget.height,
    //   child: ElevatedButton(
    //     onPressed: widget.click,
    //     style: ElevatedButton.styleFrom(
    //       // foregroundColor: Theme.of(context).colorScheme.primary,
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       // disabledBackgroundColor: Theme.of(
    //       //   context,
    //       // ).colorScheme.onSurfaceVariant,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //     ),
    //     child: Text(widget.buttonText, style: TextStyle(fontSize: 12)),
    //   ),
    // );
  }
}
