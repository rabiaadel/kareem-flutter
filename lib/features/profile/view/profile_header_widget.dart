import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/parent_model.dart';
import '../../../shared/widgets/avatar_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;
  final bool isOwnProfile;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onEditProfile;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
    this.isOwnProfile = false,
    this.isFollowing = false,
    this.onFollowTap,
    this.onEditProfile,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar and Basic Info
          Row(
            children: [
              AvatarWidget(
                imageUrl: user.avatarUrl,
                name: user.name,
                size: 80,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role.isDoctor ? 'طبيب' : 'ولي أمر',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bio
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              user.bio!,
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Doctor-specific info
          if (user is DoctorModel) ...[
            const SizedBox(height: 16),
            _buildDoctorInfo(user as DoctorModel),
          ],

          // Parent-specific info
          if (user is ParentModel) ...[
            const SizedBox(height: 16),
            _buildParentInfo(user as ParentModel),
          ],

          // Stats
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                label: 'منشورات',
                value: '0', // TODO: Get from user
                onTap: null,
              ),
              _buildStatItem(
                label: 'متابِعون',
                value: user.followersCount.toString(),
                onTap: onFollowersTap,
              ),
              _buildStatItem(
                label: 'متابَعون',
                value: user.followingCount.toString(),
                onTap: onFollowingTap,
              ),
            ],
          ),

          // Action Button
          const SizedBox(height: 20),
          if (isOwnProfile)
            _buildEditButton()
          else
            _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo(DoctorModel doctor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Colors.white.withOpacity(0.9),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doctor.specialization,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.work_outline_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                doctor.experienceText,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.people_outline_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${doctor.patientsCount} مريض',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParentInfo(ParentModel parent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.child_care_rounded,
            color: Colors.white.withOpacity(0.9),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            parent.childName,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            parent.childAgeText,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.h2.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onEditProfile,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('تعديل الملف الشخصي'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onFollowTap,
        icon: Icon(isFollowing ? Icons.person_remove_rounded : Icons.person_add_rounded),
        label: Text(isFollowing ? 'إلغاء المتابعة' : 'متابعة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing
              ? Colors.white.withOpacity(0.2)
              : Colors.white,
          foregroundColor: isFollowing ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isFollowing
                ? const BorderSide(color: Colors.white, width: 1)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}