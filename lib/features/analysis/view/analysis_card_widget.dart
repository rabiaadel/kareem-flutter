import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/child_analysis_model.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/state_badge.dart';
import 'state_bullet_widget.dart';

class AnalysisCardWidget extends StatelessWidget {
  final ChildAnalysisModel analysis;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const AnalysisCardWidget({
    super.key,
    required this.analysis,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: analysis.currentState.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(analysis.childName, style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.formatDate(analysis.date),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: analysis.currentState),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, size: 16, color: AppColors.mutedForeground),
                    const SizedBox(width: 6),
                    Text('د. ${analysis.doctorName}', style: AppTextStyles.caption.copyWith(color: AppColors.mutedForeground)),
                  ],
                ),
                if (analysis.hasNotes) ...[
                  const SizedBox(height: 12),
                  Text('الملاحظات:', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(analysis.notes!, style: AppTextStyles.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 16),
                Text('تطور الحالة:', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: analysis.states.map((state) => StateBulletWidget(
                    state: state.state,
                    label: state.label,
                    isActive: state.isActive,
                  )).toList(),
                ),
              ],
            ),
          ),
          if (showActions && (onEdit != null || onDelete != null))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('تعديل'),
                    ),
                  if (onEdit != null && onDelete != null) const SizedBox(width: 8),
                  if (onDelete != null)
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outlined, size: 18),
                      label: const Text('حذف'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}