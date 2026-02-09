import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../data/datasources/local_data_source.dart';
import '../../../core/di/dependency_injection.dart';

/// Splash Screen - Enhanced Entry Point
///
/// Features:
/// - Beautiful animations (fade, scale, slide)
/// - Auto-navigation logic
/// - Onboarding check
/// - Auth state verification
/// - Error handling
/// - Progress indicator
/// - Custom transitions
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  String _statusMessage = 'جاري التحميل...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Minimum splash duration
      await Future.delayed(const Duration(milliseconds: 1500));

      _updateStatus('جاري التحقق من الحالة...');

      final localDataSource = getIt<LocalDataSource>();
      final authProvider = context.read<AuthProvider>();

      // Check onboarding
      if (!localDataSource.isOnboardingCompleted()) {
        _updateStatus('مرحباً بك!');
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateTo(RouteNames.onboarding);
        return;
      }

      // Check authentication
      _updateStatus('جاري التحقق من الحساب...');
      await authProvider.init();

      if (authProvider.isAuthenticated) {
        _updateStatus('مرحباً ${authProvider.currentUser?.name ?? ""}!');
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateTo(RouteNames.mainLayout);
      } else {
        _updateStatus('اختر نوع حسابك');
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateTo(RouteNames.roleSelection);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _statusMessage = 'حدث خطأ: ${e.toString()}';
      });

      // Navigate to safe screen after error
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateTo(RouteNames.roleSelection);
      }
    }
  }

  void _updateStatus(String message) {
    if (mounted) {
      setState(() => _statusMessage = message);
    }
  }

  void _navigateTo(String routeName) {
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Container
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // App Name with slide animation
                        SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Lumo AI',
                                style: AppTextStyles.h1.copyWith(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'رعاية طبية ذكية لأطفالك',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Status Message
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_hasError) ...[
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ] else
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              if (_hasError) const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _statusMessage,
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Version Info
                        Text(
                          'الإصدار 1.0.0',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}