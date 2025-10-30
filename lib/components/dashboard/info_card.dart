import 'package:flutter/material.dart';
import 'package:invengo/constant/app_color.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String value;
  final String label;
  final String percentage;
  final Color percentageColor;

  const InfoCard({
    required this.icon,
    required this.iconBgColor,
    required this.value,
    required this.label,
    required this.percentage,
    required this.percentageColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffe5e7eb)),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 202,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          SizedBox(height: 24),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: AppColor.primaryTextLight),
          ),
          SizedBox(height: 24),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.primaryTextLightOpacity60,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.trending_up, color: percentageColor),
              Text(percentage, style: TextStyle(color: percentageColor)),
            ],
          ),
        ],
      ),
    );
  }
}
