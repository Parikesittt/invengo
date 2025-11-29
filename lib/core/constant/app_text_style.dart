import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle header(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle subHeader(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface.withOpacity(0.8),
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface.withOpacity(0.9),
    );
  }

  static TextStyle cardValue(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle growth(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF12B76A), 
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle sectionSubtitle(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }

  static TextStyle h1(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle h2(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle h3(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle h4(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle p(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle pPrice(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle label(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 12,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }

  static TextStyle button(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onPrimary,
    );
  }
}
