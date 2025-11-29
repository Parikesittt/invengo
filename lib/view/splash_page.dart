import 'dart:async';
import 'dart:math';
import 'dart:ui';
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
  late final AnimationController _waveController; 
  late final AnimationController _glowController; 
  late final AnimationController _ringController; 
  late final AnimationController _progressController; 
  late final AnimationController _scanController; 

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _start();
  }

  void _start() {
    _progressController.forward();
    Future.delayed(const Duration(milliseconds: 2100), () async {
      final isLogin = await PreferenceHandler.getLogin();
      if (!mounted) return;
      if (isLogin == true) {
        context.router.replace(const MainFirebaseRoute());
      } else {
        context.router.replace(const LoginRouteFirebase());
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _glowController.dispose();
    _ringController.dispose();
    _progressController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  static const Color cPurple = Color(0xFF7C3AED);
  static const Color cPink = Color(0xFFEC4899);
  static const Color cCyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final dark = brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: dark ? const Color(0xFF03040A) : const Color(0xFF050918),
          ),

          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) {
              return CustomPaint(
                painter: _NeonBandPainter(
                  t: _waveController.value,
                  purple: cPurple,
                  pink: cPink,
                  cyan: cCyan,
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) {
              return CustomPaint(
                painter: _ParallaxGridPainter(
                  offset: _waveController.value,
                  color: Colors.white.withOpacity(0.03),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: Listenable.merge([_ringController, _glowController]),
            builder: (_, __) {
              return IgnorePointer(
                child: CustomPaint(
                  painter: _NeonRingsPainter(
                    t: _ringController.value,
                    glowStrength: _glowController.value,
                    purple: cPurple,
                    pink: cPink,
                    cyan: cCyan,
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _glowController,
                        builder: (_, child) {
                          final glow = 30 + 40 * _glowController.value;
                          return Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  cPurple.withOpacity(
                                    0.16 * (0.7 + 0.6 * _glowController.value),
                                  ),
                                  cPink.withOpacity(0.06),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          );
                        },
                      ),

                      ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 20 * (0.6 + 0.4 * _glowController.value),
                            sigmaY: 20 * (0.6 + 0.4 * _glowController.value),
                          ),
                          child: const SizedBox(width: 320, height: 320),
                        ),
                      ),

                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [cPurple, cPink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cPurple.withOpacity(0.28),
                              blurRadius: 50,
                              offset: const Offset(0, 24),
                            ),
                            BoxShadow(
                              color: cPink.withOpacity(0.14),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo_transparant.png',
                            width: 160,
                            height: 160,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Invengo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Smart Inventory Management',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 52),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (_, __) {
                        final v = _progressController.value.clamp(0.0, 1.0);
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: v,
                                minHeight: 8,
                                backgroundColor: Colors.white12,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  cPink,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Booting',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${(v * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _scanController,
            builder: (_, __) {
              return CustomPaint(
                painter: _ScanlinePainter(
                  offset: _scanController.value,
                  color: Colors.white.withOpacity(0.03),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NeonBandPainter extends CustomPainter {
  final double t;
  final Color purple, pink, cyan;
  _NeonBandPainter({
    required this.t,
    required this.purple,
    required this.pink,
    required this.cyan,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment(-1 + 2 * t, -1),
      end: Alignment(1 - 2 * t, 1),
      colors: [
        purple.withOpacity(0.14),
        pink.withOpacity(0.12),
        cyan.withOpacity(0.08),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(rect);

    final paint = Paint()..shader = gradient;
    canvas.drawRect(rect, paint);

    final bandPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0.0 + (t - 0.5) * 0.6, -0.2),
        radius: 0.6,
        colors: [pink.withOpacity(0.18), Colors.transparent],
      ).createShader(rect);
    canvas.drawRect(rect, bandPaint);
  }

  @override
  bool shouldRepaint(covariant _NeonBandPainter old) => old.t != t;
}

class _ParallaxGridPainter extends CustomPainter {
  final double offset;
  final Color color;
  _ParallaxGridPainter({required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final spacing = 40.0;
    final dx = (offset * spacing * 0.8) % spacing;
    final dy = (offset * spacing * 0.6) % spacing;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x + dx, 0), Offset(x + dx, size.height), paint);
    }
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      canvas.drawLine(Offset(0, y + dy), Offset(size.width, y + dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParallaxGridPainter old) =>
      old.offset != offset;
}

class _NeonRingsPainter extends CustomPainter {
  final double t;
  final double glowStrength;
  final Color purple;
  final Color pink;
  final Color cyan;

  _NeonRingsPainter({
    required this.t,
    required this.glowStrength,
    required this.purple,
    required this.pink,
    required this.cyan,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2.2);
    final phases = [0.0, 0.33, 0.66];
    for (int i = 0; i < 3; i++) {
      final phase = (t + phases[i]) % 1.0;
      final radius = lerpDouble(80, min(size.width, size.height) * 0.7, phase)!;
      final opacity = (1 - phase) * 0.28 * (0.6 + 0.7 * glowStrength);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12 * (1 - phase) + 2
        ..shader = RadialGradient(
          colors: [
            (i == 0 ? purple : (i == 1 ? pink : cyan)).withOpacity(opacity),
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    final flare = Paint()
      ..shader = RadialGradient(
        colors: [pink.withOpacity(0.9), purple.withOpacity(0.0)],
        stops: const [0.0, 0.8],
      ).createShader(Rect.fromCircle(center: center, radius: 34));
    canvas.drawCircle(center, 34, flare);
  }

  @override
  bool shouldRepaint(covariant _NeonRingsPainter old) =>
      old.t != t || old.glowStrength != glowStrength;
}

class _ScanlinePainter extends CustomPainter {
  final double offset;
  final Color color;
  _ScanlinePainter({required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final spacing = 6.0;
    final yOffset = (offset * spacing * 4) % spacing;
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      final alpha = (sin((y + offset * 300) / 20) * 0.5 + 0.5) * 0.18;
      paint.color = color.withOpacity(alpha * color.opacity);
      canvas.drawRect(Rect.fromLTWH(0, y + yOffset, size.width, 1.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter old) => old.offset != offset;
}
