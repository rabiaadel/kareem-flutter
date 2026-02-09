import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';

/// Doctor Code Generator Screen - doctor generates patient connection codes
class DoctorCodeGeneratorScreen extends StatefulWidget {
  const DoctorCodeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<DoctorCodeGeneratorScreen> createState() =>
      _DoctorCodeGeneratorScreenState();
}

class _DoctorCodeGeneratorScreenState extends State<DoctorCodeGeneratorScreen> {
  String? _generatedCode;

  void _generateCode() {
    final code = _generateRandomCode();
    setState(() {
      _generatedCode = code;
    });
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[(DateTime.now().millisecondsSinceEpoch + i) % chars.length];
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'إنشاء رمز للمرضى',
        onBackPressed: () => Navigator.pop(context),
      ) as PreferredSizeWidget?,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_generatedCode != null) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('رمزك الفريد:'),
                      const SizedBox(height: 12),
                      Text(
                        _generatedCode!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم النسخ')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('نسخ الرمز'),
                ),
              ] else
                ElevatedButton(
                  onPressed: _generateCode,
                  child: const Text('إنشاء رمز جديد'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
