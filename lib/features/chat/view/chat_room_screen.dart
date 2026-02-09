import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/providers/auth_provider.dart';
import '../view_model/chat_view_model.dart';
import 'message_bubble.dart';
import 'chat_input_widget.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatRoomScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
    _viewModel.loadMessages(widget.chatRoomId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _handleSend() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return;

    _messageController.clear();

    await _viewModel.sendMessage(
      chatRoomId: widget.chatRoomId,
      senderId: currentUser.id,
      senderName: currentUser.name,
      senderAvatarUrl: currentUser.avatarUrl,
      content: content,
    );

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.currentUser?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.otherUserName,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            AvatarWidget(
              imageUrl: widget.otherUserAvatar,
              name: widget.otherUserName,
              size: 32,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              // TODO: Voice call
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {
              // TODO: Video call
            },
          ),
        ],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.messages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.messages.isEmpty) {
            return Column(
              children: [
                const Expanded(
                  child: EmptyState(
                    icon: Icons.chat_outlined,
                    title: 'لا توجد رسائل بعد',
                    message: 'ابدأ المحادثة الآن',
                  ),
                ),
                ChatInputWidget(
                  controller: _messageController,
                  onSend: _handleSend,
                  isLoading: viewModel.isSending,
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[index];
                    final isMe = message.senderId == currentUserId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                ),
              ),
              ChatInputWidget(
                controller: _messageController,
                onSend: _handleSend,
                onAttach: () {
                  // TODO: Attach file
                },
                isLoading: viewModel.isSending,
              ),
            ],
          );
        },
      ),
    );
  }
}