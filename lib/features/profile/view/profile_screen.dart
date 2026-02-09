import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/repositories/profile_repository.dart';
import '../view_model/profile_view_model.dart';
import 'profile_header_widget.dart';

/// Profile Screen - user profile and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      repository: context.read<ProfileRepository>(),
    );
    _viewModel.loadProfile('current_user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'الملف الشخصي',
        showBackButton: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              icon: const Icon(Icons.settings),
              color: AppColors.primary,
              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            ),
          ),
        ],
      ) as PreferredSizeWidget?,
      body: ChangeNotifierProvider<ProfileViewModel>.value(
        value: _viewModel,
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  ProfileHeaderWidget(
                    name: viewModel.userName,
                    followers: viewModel.followers,
                    following: viewModel.following,
                    role: viewModel.userRole,
                  ),
                  // Menu items
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.edit,
                          title: 'تعديل الملف الشخصي',
                          onTap: () =>
                              Navigator.pushNamed(context, '/edit-profile'),
                        ),
                        _buildMenuTile(
                          icon: Icons.people,
                          title: 'المتابعون',
                          onTap: () =>
                              Navigator.pushNamed(context, '/followers'),
                        ),
                        _buildMenuTile(
                          icon: Icons.person_add,
                          title: 'المتابعة',
                          onTap: () =>
                              Navigator.pushNamed(context, '/following'),
                        ),
                        if (viewModel.userRole == 'parent')
                          _buildMenuTile(
                            icon: Icons.local_hospital,
                            title: 'طلب التحاق بطبيب',
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/doctor-request',
                            ),
                          ),
                        if (viewModel.userRole == 'doctor')
                          _buildMenuTile(
                            icon: Icons.vpn_key,
                            title: 'إنشاء رمز للمرضى',
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/doctor-code',
                            ),
                          ),
                        _buildMenuTile(
                          icon: Icons.logout,
                          title: 'تسجيل الخروج',
                          isDestructive: true,
                          onTap: () => _showLogoutDialog(context, viewModel),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.destructive : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: isDestructive
                      ? AppColors.destructive
                      : AppColors.foreground,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'تسجيل الخروج',
          style: AppTextStyles.h2,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.destructive,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
