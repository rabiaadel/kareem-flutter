import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/onboarding_model.dart';
import '../../../data/datasources/local_data_source.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../shared/widgets/app_button.dart';
import 'onboarding_page.dart';

/// Onboarding Screen - Complete Introduction Flow
///
/// Features:
/// - 3 beautiful pages with illustrations
/// - Smooth page transitions
/// - Animated page indicators
/// - Skip functionality
/// - Progress tracking
/// - State persistence
/// - Gesture navigation
/// - Auto-advance option
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingModel> _screens = OnboardingModel.screens;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // Reset and replay fade animation
    _fadeController.reset();
    _fadeController.forward();
  }

  Future<void> _completeOnboarding() async {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);

    try {
      final localDataSource = getIt<LocalDataSource>();
      await localDataSource.setOnboardingCompleted(true);

      if (!mounted) return;

      // Navigate with fade transition
      Navigator.pushReplacementNamed(context, RouteNames.roleSelection);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isNavigating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: AppColors.destructive,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar - Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only show if not on first page)
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      tooltip: 'السابق',
                    )
                  else
                    const SizedBox(width: 48),

                  // Skip button (hide on last page)
                  if (_currentPage < _screens.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'تخطي',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // PageView - Main Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _screens.length,
                  itemBuilder: (context, index) {
                    final screen = _screens[index];
                    return OnboardingPage(
                      title: screen.title,
                      description: screen.description,
                      imagePath: screen.imagePath,
                      currentPage: index,
                      totalPages: _screens.length,
                    );
                  },
                ),
              ),
            ),

            // Bottom Section - Indicators and Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _screens.length,
                          (index) => _buildPageIndicator(index),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Navigation Button
                  AppButton(
                    text: _currentPage == _screens.length - 1
                        ? 'ابدأ الآن'
                        : 'التالي',
                    onPressed: _isNavigating ? null : _nextPage,
                    isLoading: _isNavigating,
                    icon: _currentPage == _screens.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                  ),

                  const SizedBox(height: 16),

                  // Progress Text
                  Text(
                    'صفحة ${_currentPage + 1} من ${_screens.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedForeground,
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

  Widget _buildPageIndicator(int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.mutedForeground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
    );
  }
}