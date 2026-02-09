import 'package:flutter/material.dart';
import '../../../data/repositories/profile_repository.dart';

/// Profile View Model - manages profile screen state and logic
class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileViewModel({required this.repository});

  String _userName = '';
  String _userRole = 'parent';
  int _followers = 0;
  int _following = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get userName => _userName;
  String get userRole => _userRole;
  int get followers => _followers;
  int get following => _following;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await repository.getUserProfile(userId);
      if (user != null) {
        _userName = user.name ?? 'المستخدم';
        _userRole = user.role ?? 'parent';
        _followers = user.followersCount ?? 0;
        _following = user.followingCount ?? 0;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'فشل تحميل الملف الشخصي: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await repository.updateProfile(data);
      if (success) {
        if (data.containsKey('name')) _userName = data['name'];
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'فشل تحديث الملف الشخصي: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.logout();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل تسجيل الخروج: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
