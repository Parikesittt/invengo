import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';

class StockButton extends StatefulWidget {
  const StockButton({
    super.key,
    required this.isEnable,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final bool isEnable;
  final IconData icon;
  final String title;
  final String subtitle;
  final Function()? onTap;

  @override
  State<StockButton> createState() => _StockButtonState();
}

class _StockButtonState extends State<StockButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: widget.isEnable
              ? Border.fromBorderSide(BorderSide(color: AppColor.primary))
              : Border.fromBorderSide(BorderSide(color: AppColor.borderLight)),
          gradient: LinearGradient(
            colors: widget.isEnable
                ? [Color(0x108B5CF6), Color(0x10EC4899)]
                : [Colors.white, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: widget.isEnable
                      ? AppColor.primaryGradient
                      : [Color(0xfff3f4f6), Color(0xfff3f4f6)],
                ),
              ),
              child: Icon(
                widget.icon,
                color: widget.isEnable ? Colors.white : Color(0xff4a5565),
              ),
            ),
            h(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: AppColor.primaryTextLight,
                    fontSize: 15,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: AppColor.primaryTextLightOpacity80,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
