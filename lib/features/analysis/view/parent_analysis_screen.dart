import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/providers/auth_provider.dart';
import '../view_model/analysis_view_model.dart';
import 'analysis_card_widget.dart';

class ParentAnalysisScreen extends StatefulWidget {
  const ParentAnalysisScreen({super.key});

  @override
  State<ParentAnalysisScreen> createState() => _ParentAnalysisScreenState();
}

class _ParentAnalysisScreenState extends State<ParentAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.id ?? '';
      context.read<AnalysisViewModel>().loadParentAnalyses(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'تحليلات طفلي',
        showBackButton: false,
      ),
      body: Consumer<AnalysisViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.analyses.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerCard(),
            );
          }

          if (viewModel.analyses.isEmpty) {
            return const EmptyState(
              icon: Icons.analytics_outlined,
              title: 'لا توجد تحليلات بعد',
              message: 'سيظهر هنا تحليلات صحة طفلك من الطبيب المتابع',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.id ?? '';
              await viewModel.loadParentAnalyses(userId);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.analyses.length,
              itemBuilder: (context, index) {
                final analysis = viewModel.analyses[index];
                return AnalysisCardWidget(
                  analysis: analysis,
                  onTap: () {
                    // TODO: Navigate to detail
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}