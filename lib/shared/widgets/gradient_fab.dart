    import 'package:flutter/material.dart';

    class GradientFab extends StatelessWidget {
      final VoidCallback onPressed;
      final Widget child;
      final List<Color> gradientColors;

      const GradientFab({
        Key? key,
        required this.onPressed,
        required this.child,
        required this.gradientColors,
      }) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle, // For a circular FAB
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent, // Important for the gradient to show
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(56 / 2), // Half of FAB size for perfect circle
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                child: child,
              ),
            ),
          ),
        );
      }
    }