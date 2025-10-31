import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final bool withBorder;
  final Gradient? gradient;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.withBorder = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: withBorder
            ? Border.all(color: Theme.of(context).colorScheme.outline)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
