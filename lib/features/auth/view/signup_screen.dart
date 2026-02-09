import 'package:flutter/material.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/enums/user_role.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/mixins/form_validation_mixin.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/di/dependency_injection.dart';

/// Signup Screen
///
/// User registration with role-specific fields
/// Features:
/// - Common fields (name, email, password, phone)
/// - Parent fields (child name, age)
/// - Doctor fields (specialization, license, experience)
/// - Complete validation
/// - Loading state
class SignupScreen extends StatefulWidget {
  final UserRole? selectedRole;

  const SignupScreen({super.key, this.selectedRole});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with FormValidationMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Parent fields
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();

  // Doctor fields
  final _specializationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _isLoading = false;
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole ?? UserRole.parent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _childNameController.dispose();
    _childAgeController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = getIt<AuthRepository>();

      await authRepo.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        childName: _selectedRole.isParent ? _childNameController.text.trim() : null,
        childAge: _selectedRole.isParent ? int.tryParse(_childAgeController.text) : null,
        specialization: _selectedRole.isDoctor ? _specializationController.text.trim() : null,
        licenseNumber: _selectedRole.isDoctor ? _licenseNumberController.text.trim() : null,
        yearsOfExperience: _selectedRole.isDoctor ? int.tryParse(_experienceController.text) : null,
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.mainLayout,
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.destructive,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'إنشاء حساب جديد',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedRole.isDoctor ? 'حساب طبيب' : 'حساب ولي أمر',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Common fields
                AppTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  hint: 'أدخل اسمك الكامل',
                  prefixIcon: Icons.person_outlined,
                  validator: validateName,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hint: 'أدخل بريدك الإلكتروني',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hint: 'أدخل كلمة المرور (8 أحرف على الأقل)',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  validator: validatePassword,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  hint: 'أعد إدخال كلمة المرور',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  validator: (value) => validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف (اختياري)',
                  hint: 'أدخل رقم هاتفك',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: validatePhone,
                ),

                // Role-specific fields
                if (_selectedRole.isParent) ...[
                  const SizedBox(height: 24),
                  Text(
                    'معلومات الطفل',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _childNameController,
                    label: 'اسم الطفل',
                    hint: 'أدخل اسم الطفل',
                    prefixIcon: Icons.child_care_outlined,
                    validator: validateChildName,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _childAgeController,
                    label: 'عمر الطفل (بالسنوات)',
                    hint: 'أدخل عمر الطفل',
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    validator: validateAge,
                  ),
                ],

                if (_selectedRole.isDoctor) ...[
                  const SizedBox(height: 24),
                  Text(
                    'المعلومات المهنية',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _specializationController,
                    label: 'التخصص الطبي',
                    hint: 'مثال: طب أطفال، جراحة أطفال',
                    prefixIcon: Icons.medical_services_outlined,
                    validator: validateSpecialization,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _licenseNumberController,
                    label: 'رقم الترخيص',
                    hint: 'أدخل رقم الترخيص الطبي',
                    prefixIcon: Icons.badge_outlined,
                    validator: validateLicenseNumber,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _experienceController,
                    label: 'سنوات الخبرة',
                    hint: 'عدد سنوات الخبرة في المجال',
                    prefixIcon: Icons.work_outline,
                    keyboardType: TextInputType.number,
                  ),
                ],

                const SizedBox(height: 32),
                AppButton(
                  text: 'إنشاء الحساب',
                  onPressed: _handleSignup,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}