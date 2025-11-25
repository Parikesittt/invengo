import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invengo/core/services/preference_handler.dart';
import 'package:invengo/core/config/route.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late AnimationController _orbController;
  late Animation<double> _progressAnimation;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    isLoginFunction();
  }

  void _setupAnimations() {
    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_progressController)
          ..addListener(() {
            setState(() {
              progress = _progressAnimation.value * 100;
            });
          });

    _progressController.forward();

    // Orb floating animation
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  isLoginFunction() async {
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      var isLogin = await PreferenceHandler.getLogin();
      debugPrint("isLogin: $isLogin");

      if (!mounted) return; // mastiin widget masih aktif

      if (isLogin != null && isLogin == true) {
        context.router.replace(const MainFirebaseRoute());
      } else {
        context.router.replace(const LoginRouteFirebase());
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF4C1D95),
                    Color(0xFF0F172A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFF5F3FF),
                    Color(0xFFFDF2F8),
                    Color(0xFFF5F3FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Stack(
          children: [
            // Background Orbs
            Positioned(
              top: 100,
              left: 40,
              child: AnimatedBuilder(
                animation: _orbController,
                builder: (context, child) {
                  double scale = 1 + 0.2 * _orbController.value;
                  double opacity = 0.3 + 0.2 * _orbController.value;
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 100,
              right: 40,
              child: AnimatedBuilder(
                animation: _orbController,
                builder: (context, child) {
                  double scale = 1.2 - 0.2 * _orbController.value;
                  double opacity = 0.3 + 0.2 * (1 - _orbController.value);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEC4899),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Center Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo bounce animation
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      double offsetY =
                          -10 * (0.5 - (0.5 - _logoController.value).abs());
                      return Transform.translate(
                        offset: Offset(0, offsetY),
                        child: Image.asset(
                          'assets/images/logo_transparant.png', // ganti sesuai path logo kamu
                          width: 250,
                          height: 250,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Invengo",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Smart Inventory Management",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Progress Bar
                  Container(
                    width: 160,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress / 100,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
