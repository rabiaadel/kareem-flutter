import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../data/repositories/profile_repository.dart';
import '../view_model/profile_view_model.dart';

/// Edit Profile Screen - edit user information
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      repository: context.read<ProfileRepository>(),
    );
    _nameController.text = _viewModel.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'تعديل الملف الشخصي',
        onBackPressed: () => Navigator.pop(context),
      ) as PreferredSizeWidget?,
      body: ChangeNotifierProvider<ProfileViewModel>.value(
        value: _viewModel,
        child: Consumer<ProfileViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    label: 'الاسم الكامل',
                    hint: 'أدخل اسمك الكامل',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'رقم الهاتف',
                    hint: 'أدخل رقم هاتفك',
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'حفظ التغييرات',
                    isLoading: viewModel.isLoading,
                    onPressed: () {
                      viewModel.updateProfile({
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _viewModel.dispose();
    super.dispose();
  }
}
