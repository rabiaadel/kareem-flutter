import 'package:flutter/material.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/avatar_widget.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _patients.addAll([
        {
          'id': '1',
          'name': 'أحمد محمد',
          'childName': 'محمد',
          'childAge': 5,
          'avatar': null
        },
        {
          'id': '2',
          'name': 'فاطمة علي',
          'childName': 'سارة',
          'childAge': 3,
          'avatar': null
        },
      ]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'مرضاي',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.doctorCodeGenerator);
            },
            tooltip: 'مشاركة الكود',
          ),
        ],
      ),
      body: _isLoading
          ? ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => const ShimmerListTile(),
      )
          : _patients.isEmpty
          ? const EmptyState(
        icon: Icons.people_outline,
        title: 'لا يوجد مرضى بعد',
        message: 'قم بمشاركة كود الطبيب مع أولياء الأمور للبدء',
      )
          : RefreshIndicator(
        onRefresh: _loadPatients,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _patients.length,
          itemBuilder: (context, index) {
            final patient = _patients[index];
            return ElevatedCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.doctorPatientDetail,
                  arguments: {
                    'parentId': patient['id'],
                    'parentName': patient['name'],
                    'childName': patient['childName'],
                  },
                );
              },
              child: Row(
                children: [
                  AvatarWidget(
                    imageUrl: patient['avatar'],
                    name: patient['name'],
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.child_care_rounded,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${patient['childName']} (${patient['childAge']} سنوات)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}