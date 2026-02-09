import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/providers/auth_provider.dart';
import '../view_model/community_view_model.dart';

/// Posts Feed Widget
///
/// Displays scrollable list of posts with actions
class PostsFeedWidget extends StatelessWidget {
  const PostsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.posts.isEmpty) {
          return ListView.builder(
            itemCount: 5,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ShimmerCard(),
            ),
          );
        }

        if (viewModel.posts.isEmpty) {
          return const EmptyState(
            icon: Icons.article_outlined,
            title: 'لا توجد منشورات بعد',
            message: 'كن أول من ينشر في المجتمع',
          );
        }

        return ListView.builder(
          itemCount: viewModel.posts.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final post = viewModel.posts[index];
            final authProvider = context.read<AuthProvider>();
            final currentUserId = authProvider.currentUser?.id ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedCard(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.postDetail,
                    arguments: post.id,
                  );
                },
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Post Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          AvatarWidget(
                            imageUrl: post.userAvatarUrl,
                            name: post.userName,
                            size: 40,
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
                          if (post.userId == currentUserId)
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: AppColors.mutedForeground,
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.editPost,
                                    arguments: post,
                                  );
                                } else if (value == 'delete') {
                                  _showDeleteDialog(context, viewModel, post.id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined),
                                      SizedBox(width: 8),
                                      Text('تعديل'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outlined,
                                        color: AppColors.destructive,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'حذف',
                                        style: TextStyle(
                                          color: AppColors.destructive,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Post Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        post.content,
                        style: AppTextStyles.body,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Post Image
                    if (post.hasImage && post.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            post.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    // Actions
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildActionButton(
                            context,
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
                            context,
                            icon: Icons.comment_outlined,
                            label: post.commentsCount.toString(),
                            color: AppColors.mutedForeground,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.postDetail,
                                arguments: post.id,
                              );
                            },
                          ),
                          const SizedBox(width: 24),
                          _buildActionButton(
                            context,
                            icon: Icons.share_outlined,
                            label: post.sharesCount.toString(),
                            color: AppColors.mutedForeground,
                            onTap: () {
                              // TODO: Share
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
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

  void _showDeleteDialog(
      BuildContext context,
      CommunityViewModel viewModel,
      String postId,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('حذف المنشور'),
        content: const Text('هل أنت متأكد من حذف هذا المنشور؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deletePost(postId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.destructive,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}