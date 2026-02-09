import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/notification_provider.dart';
import '../view_model/community_view_model.dart';
import 'posts_feed_widget.dart';

/// Community Screen - Main social feed
///
/// Fully integrated with:
/// - AuthProvider (current user)
/// - NotificationProvider (post notifications)
/// - CommunityViewModel (posts state)
/// - CommunityRepository (data layer)
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final viewModel = context.read<CommunityViewModel>();
    final authProvider = context.read<AuthProvider>();

    if (authProvider.currentUser != null) {
      await viewModel.loadPosts();

      // Mark notifications as read
      if (mounted) {
        context.read<NotificationProvider>().markPostNotificationsAsRead();
      }
    }
  }

  Future<void> _handleRefresh() async {
    final viewModel = context.read<CommunityViewModel>();
    await viewModel.loadPosts();
  }

  void _navigateToCreatePost() {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.currentUser == null) {
      _showLoginRequired();
      return;
    }

    Navigator.pushNamed(context, RouteNames.createPost).then((_) {
      // Reload posts after creating
      _handleRefresh();
    });
  }

  void _showLoginRequired() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('يجب تسجيل الدخول أولاً'),
        backgroundColor: AppColors.destructive,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'المجتمع',
        showBackButton: false,
        actions: [
          // Notification badge
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              final unreadCount = notificationProvider.unreadPostNotifications;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.notifications);
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.destructive,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreatePost,
        icon: const Icon(Icons.add_rounded),
        label: const Text('منشور جديد'),
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: const PostsFeedWidget(),
      ),
    );
  }
}