import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/user_chip_widget.dart';
import '../../../shared/providers/auth_provider.dart';
import '../view_model/chat_view_model.dart';
import 'new_chat_dialog.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  late ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id ?? '';
    _viewModel.loadChatRooms(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'المحادثات',
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NewChatDialog.show(
            context,
            onUserSelected: (userId, userName) {
              // TODO: Create or navigate to chat room
              Navigator.pushNamed(
                context,
                RouteNames.chatRoom,
                arguments: {
                  'chatRoomId': 'chat_$userId',
                  'otherUserName': userName,
                  'otherUserAvatar': null,
                },
              );
            },
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_outlined),
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.chatRooms.isEmpty) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerListTile(),
            );
          }

          if (viewModel.chatRooms.isEmpty) {
            return const EmptyState(
              icon: Icons.chat_outlined,
              title: 'لا توجد محادثات بعد',
              message: 'ابدأ محادثة جديدة مع الأطباء أو أولياء الأمور',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.id ?? '';
              await viewModel.loadChatRooms(userId);
            },
            child: ListView.builder(
              itemCount: viewModel.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = viewModel.chatRooms[index];
                final authProvider = context.read<AuthProvider>();
                final currentUserId = authProvider.currentUser?.id ?? '';

                final otherUserId = chatRoom.getOtherParticipantId(currentUserId);
                final otherUserName = chatRoom.getOtherParticipantName(currentUserId);
                final otherUserAvatar = chatRoom.getOtherParticipantAvatar(currentUserId);
                final unreadCount = chatRoom.getUnreadCount(currentUserId);

                return UserChipWidget(
                  name: otherUserName,
                  avatarUrl: otherUserAvatar,
                  subtitle: chatRoom.lastMessage ?? 'لا توجد رسائل',
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (chatRoom.lastMessageTimestamp != null)
                        Text(
                          DateFormatter.formatRelativeTime(
                            chatRoom.lastMessageTimestamp!,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      if (unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.chatRoom,
                      arguments: {
                        'chatRoomId': chatRoom.id,
                        'otherUserName': otherUserName,
                        'otherUserAvatar': otherUserAvatar,
                      },
                    );
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