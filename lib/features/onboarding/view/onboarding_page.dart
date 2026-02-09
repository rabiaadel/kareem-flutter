import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Onboarding Page Component
///
/// Features:
/// - Beautiful illustration placeholder
/// - Animated entrance
/// - Responsive layout
/// - RTL support
/// - Custom styling
class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final int currentPage;
  final int totalPages;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getPageColor() {
    switch (widget.currentPage) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.secondary;
      case 2:
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }

  IconData _getPageIcon() {
    switch (widget.currentPage) {
      case 0:
        return Icons.health_and_safety_rounded;
      case 1:
        return Icons.people_rounded;
      case 2:
        return Icons.analytics_rounded;
      default:
        return Icons.health_and_safety_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageColor = _getPageColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Illustration
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    pageColor.withOpacity(0.1),
                    pageColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: pageColor.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: pageColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getPageIcon(),
                    size: 80,
                    color: pageColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Animated Title and Description
          SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Title
                Text(
                  widget.title,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Description
                Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    widget.description,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.mutedForeground,
                      fontSize: 16,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Feature Highlights (optional based on page)
                if (widget.currentPage == 0)
                  _buildFeatureHighlights([
                    'متابعة صحة طفلك بسهولة',
                    'تواصل مع أفضل الأطباء',
                    'مساعد ذكي متوفر دائماً',
                  ], pageColor),

                if (widget.currentPage == 1)
                  _buildFeatureHighlights([
                    'مجتمع داعم من الآباء',
                    'محادثات آمنة مع الأطباء',
                    'مشاركة التجارب والنصائح',
                  ], pageColor),

                if (widget.currentPage == 2)
                  _buildFeatureHighlights([
                    'تحليلات صحية دقيقة',
                    'تتبع التطور الصحي',
                    'تقارير مفصلة ومنظمة',
                  ], pageColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights(List<String> features, Color color) {
    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  feature,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.foreground,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}