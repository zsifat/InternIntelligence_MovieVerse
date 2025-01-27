import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/viewmodels/auth_state_viewmodel.dart';
import 'package:movie_app/viewmodels/user_profile_viewmodel.dart';
import 'package:movie_app/views/login_screen.dart';
import 'package:movie_app/views/reviewed_movie_screen.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);

    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userProfileState.userProfile?.userName.toUpperCase() ?? 'User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options
            _buildSettingsOption(
              context,
              title: 'Account Settings',
              icon: CupertinoIcons.person,
              onTap: () {
                // Navigate to account settings
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Your Reviews',
              icon: CupertinoIcons.square_list,
              onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReviewScreen(),
                    ),
                  );

              },
            ),
            _buildSettingsOption(
              context,
              title: 'Help & Support',
              icon: CupertinoIcons.question_circle,
              onTap: () {
                // Navigate to help and support
              },
            ),

            const SizedBox(height: 30),

            // Logout Button
      CupertinoButton(
        color: CupertinoColors.systemRed,
        child: const Text('Logout'),
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('No'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      ref.read(authViewModelProvider.notifier).logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
        },
      ),

          ],
        ),
      ),
    );
  }

  // Builds a single settings option row
  Widget _buildSettingsOption(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondaryLabel,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: CupertinoColors.activeBlue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppSettings.regular,
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}
