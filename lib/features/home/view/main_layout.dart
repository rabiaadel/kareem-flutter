import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/providers/auth_provider.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../core/enums/user_role.dart';
import 'home_screen.dart';
import '../../ai_helper/view/ai_chat_screen.dart';
import '../../chat/view/chats_list_screen.dart';
import '../../analysis/view/parent_analysis_screen.dart';
import '../../analysis/view/doctor_patients_screen.dart';
import '../../profile/view/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final userRole = currentUser.role;

    final List<Widget> screens = [
      const HomeScreen(), // Home Dashboard
      const AIChatScreen(), // AI Helper
      const ChatsListScreen(), // Chats
      userRole.isDoctor
          ? const DoctorPatientsScreen() // Doctor's patients
          : const ParentAnalysisScreen(), // Parent's analyses
      ProfileScreen(userId: currentUser.id), // Profile
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        userRole: userRole,
      ),
    );
  }
}