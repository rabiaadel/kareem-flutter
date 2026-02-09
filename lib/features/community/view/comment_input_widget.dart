import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/avatar_widget.dart';

class CommentInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;
  final String? userAvatar;
  final String userName;

  const CommentInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
    this.userAvatar,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AvatarWidget(
              imageUrl: userAvatar,
              name: userName,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: controller,
                hint: 'اكتب تعليقاً...',
                maxLines: 4,
                enabled: !isLoading,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: isLoading ? null : onSend,
              icon: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.send_rounded),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}