import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyle {
  // Header (seperti "Invengo")
  static const header = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimaryLight,
  );

  // Subheader (seperti "Welcome back, Admin")
  static const subHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.textSecondaryLight,
  );

  // Card title (misal "Total Product")
  static const cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.textSecondaryLight,
  );

  // Card value (angka “24” di card)
  static const cardValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimaryLight,
  );

  // Growth text (“+12%” di bawah)
  static const growth = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF12B76A), // hijau growth
  );

  // Section title (misal “Revenue Overview”)
  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryLight,
  );

  // Section subtitle (misal “Last 30 days”)
  static const sectionSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimaryLight,
  );

  static const h1 = TextStyle(
    fontSize: 24,
    color: AppColor.primaryTextLight,
    fontWeight: FontWeight.w500,
  );

  static const h2 = TextStyle(
    fontSize: 20,
    color: AppColor.primaryTextLight,
    fontWeight: FontWeight.w500,
  );

  static const h3 = TextStyle(
    fontSize: 18,
    color: AppColor.primaryTextLight,
    fontWeight: FontWeight.w500,
  );

  static const h4 = TextStyle(
    fontSize: 16,
    color: AppColor.primaryTextLight,
    fontWeight: FontWeight.w500,
  );

  static const p = TextStyle(fontSize: 16, color: AppColor.primaryTextLight);

  static const pPrice = TextStyle(fontSize: 16, color: AppColor.primary);

  static const button = TextStyle(
    fontSize: 16,
    color: AppColor.textPrimaryDark,
  );
  static const label = TextStyle(
    fontSize: 12,
    color: AppColor.textPrimaryLight,
  );
}
