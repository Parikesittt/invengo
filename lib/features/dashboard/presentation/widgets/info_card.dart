import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_text_style.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String value;
  final String label;
  final Color percentageColor;

  const InfoCard({
    required this.icon,
    required this.iconBgColor,
    required this.value,
    required this.label,
    required this.percentageColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 168,
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
            style: AppTextStyle.h4(context),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 24),
          Text(label, style: AppTextStyle.label(context)),
        ],
      ),
    );
  }
}
