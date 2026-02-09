import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Doctor Request Screen - parent requests to connect with doctor
class DoctorRequestScreen extends StatefulWidget {
  const DoctorRequestScreen({Key? key}) : super(key: key);

  @override
  State<DoctorRequestScreen> createState() => _DoctorRequestScreenState();
}

class _DoctorRequestScreenState extends State<DoctorRequestScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'طلب التحاق بطبيب',
        onBackPressed: () => Navigator.pop(context),
      ) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'رمز الطبيب',
              hint: 'أدخل الرمز الذي أعطاك الطبيب',
              controller: _codeController,
              prefixIcon: Icons.vpn_key,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'تأكيد الطلب',
              onPressed: () {
                if (_codeController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال الطلب بنجاح'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
