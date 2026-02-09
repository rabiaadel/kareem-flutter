import '../datasources/mock_data_source.dart';
import '../models/ai_message_model.dart';

class AIRepository {
  final MockDataSource _mockDataSource;

  AIRepository(this._mockDataSource);

  // ==================== AI CHAT ====================

  Future<AIMessageModel> sendMessage(String userId, String content) async {
    // Send user message
    final userMessage = AIMessageModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Get AI response
    final aiResponse = await _mockDataSource.sendMockAIMessage(content);

    // Create AI message
    final aiMessage = AIMessageModel(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      content: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    return aiMessage;
  }

  Future<List<AIMessageModel>> getChatHistory(String userId) async {
    // TODO: Implement chat history retrieval from Firebase
    // For now, return empty list
    return [];
  }

  Future<void> clearChatHistory(String userId) async {
    // TODO: Implement chat history clearing
  }
}