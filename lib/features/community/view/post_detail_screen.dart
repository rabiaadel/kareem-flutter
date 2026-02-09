import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/providers/auth_provider.dart';
import '../view_model/community_view_model.dart';
import 'comment_input_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleAddComment() async {
    if (_commentController.text.trim().isEmpty) return;

    _commentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة التعليق بنجاح'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;
    final currentUserId = currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'تفاصيل المنشور'),
      body: Consumer<CommunityViewModel>(
        builder: (context, viewModel, child) {
          final post = viewModel.posts.firstWhere(
                (p) => p.id == widget.postId,
            orElse: () => viewModel.posts.isNotEmpty
                ? viewModel.posts.first
                : throw Exception('Post not found'),
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AppColors.card,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AvatarWidget(
                                  imageUrl: post.userAvatarUrl,
                                  name: post.userName,
                                  size: 48,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.userName,
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormatter.formatRelativeTime(
                                          post.createdAt,
                                        ),
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              post.content,
                              style: AppTextStyles.body,
                            ),
                            if (post.hasImage && post.imageUrl != null) ...[
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  post.imageUrl!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildActionButton(
                                  icon: post.isLikedBy(currentUserId)
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  label: post.likesCount.toString(),
                                  color: post.isLikedBy(currentUserId)
                                      ? AppColors.destructive
                                      : AppColors.mutedForeground,
                                  onTap: () {
                                    if (post.isLikedBy(currentUserId)) {
                                      viewModel.unlikePost(post.id, currentUserId);
                                    } else {
                                      viewModel.likePost(post.id, currentUserId);
                                    }
                                  },
                                ),
                                const SizedBox(width: 24),
                                _buildActionButton(
                                  icon: Icons.comment_outlined,
                                  label: post.commentsCount.toString(),
                                  color: AppColors.mutedForeground,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التعليقات',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'لا توجد تعليقات بعد',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (currentUser != null)
                CommentInputWidget(
                  controller: _commentController,
                  onSend: _handleAddComment,
                  userAvatar: currentUser.avatarUrl,
                  userName: currentUser.name,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}