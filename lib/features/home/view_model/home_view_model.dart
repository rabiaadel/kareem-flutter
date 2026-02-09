import 'package:flutter/material.dart';

import '../../../data/repositories/community_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/analysis_repository.dart';
import '../../../data/repositories/profile_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final CommunityRepository _communityRepository;
  final ChatRepository _chatRepository;
  final AnalysisRepository _analysisRepository;
  final ProfileRepository _profileRepository;

  HomeViewModel(
      this._communityRepository,
      this._chatRepository,
      this._analysisRepository,
      this._profileRepository,
      );

  bool _isLoading = false;
  String? _errorMessage;

  int _postsCount = 0;
  int _chatsCount = 0;
  int _analysesCount = 0;
  int _followersCount = 0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get postsCount => _postsCount;
  int get chatsCount => _chatsCount;
  int get analysesCount => _analysesCount;
  int get followersCount => _followersCount;

  // Load dashboard data
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load real data from repositories
      // Simulating data for now
      await Future.delayed(const Duration(seconds: 1));

      _postsCount = 12;
      _chatsCount = 5;
      _analysesCount = 8;
      _followersCount = 23;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadData();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}