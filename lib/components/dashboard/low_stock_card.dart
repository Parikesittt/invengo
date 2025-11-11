import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/constant/app_text_style.dart';

class LowStockCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const LowStockCard({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 294,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffFEF2C5), Color(0xffFDE78C)],
        ),
        border: Border.all(color: Color(0x30F59E0B)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 16,
                color: Color(0xffF59E0B),
              ),
              SizedBox(width: 8),
              Text("Low Stock", style: AppTextStyle.cardTitle(context)),
            ],
          ),
          SizedBox(height: 24),
          ...items.map(
            (item) => Column(
              children: [
                Row(
                  children: [
                    Text(
                      item['name'],
                      style: AppTextStyle.cardTitle(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      "${item['stock']}/${item['max']}",
                      style: AppTextStyle.cardTitle(context),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
