import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_absensi/storage/preference.dart';
import 'package:app_absensi/views/auth/login_screen.dart';
import 'package:app_absensi/views/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _bgController;
  late AnimationController _scanController;

  late Animation<double> _blurAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // 🎬 LOGO ANIMATION
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _blurAnim = Tween<double>(begin: 14, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    _scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutExpo),
    );

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoController.forward();

    // 🌈 BACKGROUND ANIMATION (lebih smooth & premium)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // ⚡ LOADING SCAN (satu arah)
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 6));

    final isLoggedIn = await PreferenceHandler().getIsLogin();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const MainScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFFF0F9FF),
                    const Color(0xFFEDE9FE),
                    _bgController.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFEDE9FE),
                    const Color(0xFFFDF2F8),
                    _bgController.value,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // ✨ NOISE OVERLAY (biar gak flat)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: Image.asset(
                      "assets/images/noise.png", // optional (kalau ada)
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🚀 LOGO
                Center(
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) {
                      return Opacity(
                        opacity: _fadeAnim.value,
                        child: Transform.scale(
                          scale: _scaleAnim.value,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: _blurAnim.value,
                              sigmaY: _blurAnim.value,
                            ),
                            child: Image.asset(
                              "assets/images/logos/SyncAttendnBg_SplashScreen.png",
                              width: 390,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ⚡ LOADING (ONE WAY SCAN)
                Positioned(
                  bottom: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 180,
                      height: 3,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          AnimatedBuilder(
                            animation: _scanController,
                            builder: (_, __) {
                              double value = _scanController.value;

                              return Align(
                                alignment: Alignment(
                                  (value * 2) - 1, // hanya ke kanan
                                  0,
                                ),
                                child: Container(
                                  width: 60,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7C3AED), // ungu gelap
                                        Color(0xFF4C1D95), // deep purple
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
