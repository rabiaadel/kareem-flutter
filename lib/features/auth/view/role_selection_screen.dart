import 'package:flutter/material.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/enums/user_role.dart';
import '../../../shared/widgets/elevated_card.dart';

/// Role Selection Screen
///
/// First step in registration - choose user type
/// Features:
/// - Parent card (for parents monitoring children)
/// - Doctor card (for medical professionals)
/// - Beautiful card design
/// - Navigation to signup with role
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.health_and_safety_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'اختر نوع الحساب',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'اختر الدور المناسب لك للمتابعة',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Parent card
              _RoleCard(
                icon: Icons.family_restroom_rounded,
                title: 'أنا ولي أمر',
                description: 'لمتابعة صحة طفلك مع أفضل الأطباء',
                color: AppColors.primary,
                onTap: () => _navigateToSignup(context, UserRole.parent),
              ),
              const SizedBox(height: 16),

              // Doctor card
              _RoleCard(
                icon: Icons.medical_services_rounded,
                title: 'أنا طبيب',
                description: 'لتقديم الرعاية الطبية للأطفال',
                color: AppColors.secondary,
                onTap: () => _navigateToSignup(context, UserRole.doctor),
              ),

              const Spacer(),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب بالفعل؟',
                    style: AppTextStyles.body,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.login);
                    },
                    child: Text(
                      'سجل دخولك',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSignup(BuildContext context, UserRole role) {
    Navigator.pushNamed(
      context,
      RouteNames.signup,
      arguments: {'role': role},
    );
  }
}

/// Role Card Widget
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      onTap: onTap,
      padding: const EdgeInsets.all(24),
      elevation: 2,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}