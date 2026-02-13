import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../main.dart';

import '../../../core/services/drive_backup_service.dart';
import '../../../core/services/aws_auth_service.dart';
import '../../../core/services/feedback_service.dart';

/// Settings screen with Google Sign-In and backup
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dailyReminders = true;
  bool _weeklyReports = false;
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final awsAuthState = ref.watch(awsAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              _SettingsSection(
                title: 'Account',
                children: [
                  if (awsAuthState.isSignedIn) ...[
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.person,
                                color: AppColors.primary),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  awsAuthState.user?.username ?? 'User',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Signed in with AWS',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => _signOut(context),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Sign in to sync your habits',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/login'),
                            icon: const Icon(Icons.login_rounded, size: 24),
                            label: const Text('Sign In / Sign Up'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ).animate().fadeIn(delay: 100.ms),

              // Notifications Section
              _SettingsSection(
                title: 'Notifications',
                children: [
                  _SettingsSwitch(
                    icon: Icons.notifications_rounded,
                    title: 'Daily Reminders',
                    subtitle: 'Get reminded to complete your habits',
                    value: _dailyReminders,
                    onChanged: (v) => setState(() => _dailyReminders = v),
                  ),
                  _SettingsSwitch(
                    icon: Icons.summarize_rounded,
                    title: 'Weekly Reports',
                    subtitle: 'Receive weekly progress summary',
                    value: _weeklyReports,
                    onChanged: (v) => setState(() => _weeklyReports = v),
                  ),
                ],
              ).animate().fadeIn(delay: 150.ms),

              // Preferences Section
              _SettingsSection(
                title: 'Preferences',
                children: [
                  _SettingsTile(
                    icon: Icons.emoji_events_rounded,
                    title: 'Badges & Achievements',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/badges'),
                  ),
                  _SettingsSwitch(
                    icon: Icons.volume_up_rounded,
                    title: 'Sound Effects',
                    subtitle: 'Play sounds for completions',
                    value: _soundEffects,
                    onChanged: (v) => setState(() => _soundEffects = v),
                  ),
                  _SettingsSwitch(
                    icon: Icons.vibration_rounded,
                    title: 'Haptic Feedback',
                    subtitle: 'Vibrate on interactions',
                    value: _hapticFeedback,
                    onChanged: (v) => setState(() => _hapticFeedback = v),
                  ),
                  _SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Theme',
                    trailing: Text(
                      _selectedTheme,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    onTap: () => _showThemeSelector(context),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),

              // Data Section
              _SettingsSection(
                title: 'Data',
                children: [
                  _SettingsTile(
                    icon: Icons.backup_rounded,
                    title: 'Backup Data',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _backupData(context),
                  ),
                  _SettingsTile(
                    icon: Icons.download_rounded,
                    title: 'Export Summary',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _exportData(context),
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Clear All Data',
                    titleColor: AppColors.error,
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.error),
                    onTap: () => _showClearDataDialog(context),
                  ),
                ],
              ).animate().fadeIn(delay: 250.ms),

              // Support Section
              _SettingsSection(
                title: 'Support',
                children: [
                  _SettingsTile(
                    icon: Icons.feedback_rounded,
                    title: 'Send Feedback',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _sendFeedback(context, isBugReport: false),
                  ),
                  _SettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: 'Report a Problem',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _sendFeedback(context, isBugReport: true),
                  ),
                  _SettingsTile(
                    icon: Icons.star_rounded,
                    title: 'Rate Us',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _launchUrl(
                        'https://play.google.com/store/apps/details?id=com.ilabs.loop'),
                  ),
                ],
              ).animate().fadeIn(delay: 275.ms),

              // About Section
              _SettingsSection(
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Version',
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: AppTheme.spacingXl),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIconButton(
                    assetPath: 'assets/images/instagram_logo.png',
                    onTap: () => _launchUrl(
                        'https://www.instagram.com/i._labs/?utm_source=ig_web_button_share_sheet'),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  _SocialIconButton(
                    assetPath: 'assets/images/x_logo.png',
                    onTap: () => _launchUrl('https://x.com/JayDeore21'),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  _SocialIconButton(
                    assetPath: 'assets/images/linkedin_logo.png',
                    onTap: () => _launchUrl(
                        'https://www.linkedin.com/in/jay-deore-50b4b8342'),
                  ),
                ],
              ).animate().fadeIn(delay: 350.ms),

              const SizedBox(height: AppTheme.spacingMd),

              // Tutorial
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                child: _SettingsTile(
                  icon: Icons.school_rounded,
                  title: 'View Tutorial',
                  onTap: () => context.push('/tutorial'),
                ),
              ).animate().fadeIn(delay: 375.ms),

              const SizedBox(height: AppTheme.spacingLg),

              // App Logo and Brand
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/loop_habit_logo.png',
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.titleMedium,
                        children: const [
                          TextSpan(
                            text: 'i ',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: "Lab's",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await ref.read(awsAuthProvider.notifier).signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
    }
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'Select Theme',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ListTile(
            leading: const Icon(Icons.brightness_auto_rounded),
            title: const Text('System'),
            trailing: _selectedTheme == 'System'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedTheme = 'System');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.light_mode_rounded),
            title: const Text('Light'),
            trailing: _selectedTheme == 'Light'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedTheme = 'Light');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded),
            title: const Text('Dark'),
            trailing: _selectedTheme == 'Dark'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              setState(() => _selectedTheme = 'Dark');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppTheme.spacingXl),
        ],
      ),
    );
  }

  Future<void> _backupData(BuildContext context) async {
    final awsAuthState = ref.read(awsAuthProvider);

    if (!awsAuthState.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to use cloud backup')),
      );
      return;
    }

    // Show options dialog
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          return AlertDialog(
            title: const Text('Google Drive Backup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your data is backed up to a private folder in your Google Drive.',
                ),
                const SizedBox(height: AppTheme.spacingMd),
                FutureBuilder<DateTime?>(
                  future: ref
                      .read(driveBackupServiceProvider)
                      .getLastCloudBackupTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    final date = snapshot.data;
                    return Text(
                      date != null
                          ? 'Last Cloud Backup: ${date.toLocal().toString().split('.')[0]}'
                          : 'No backup found in cloud',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Restore
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Restore Data?'),
                      content: const Text(
                          'This will OVERWRITE your current data with the version from Google Drive. The app will restart.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(c, true),
                          child: const Text('Restore'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    Navigator.pop(context); // Close backup dialog
                    _performRestore(context, ref);
                  }
                },
                child: const Text('Restore'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  _performBackup(context, ref);
                },
                child: const Text('Backup Now'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _performBackup(BuildContext context, WidgetRef ref) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ref.read(driveBackupServiceProvider).backup();

    if (context.mounted) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Backup successful! ✅' : 'Backup failed ❌'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _performRestore(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ref.read(driveBackupServiceProvider).restore();

    if (context.mounted) {
      Navigator.pop(context); // Close loading

      if (success) {
        // Show restart dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => AlertDialog(
            title: const Text('Restore Complete'),
            content: const Text(
                'Data restored successfully. Please close and reopen the app to apply changes.'),
            actions: [
              FilledButton(
                onPressed: () => exit(0), // Quit app
                child: const Text('Close App'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restore failed or no backup found ❌'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  Future<void> _sendFeedback(BuildContext context,
      {required bool isBugReport}) async {
    final success = await showFeedbackDialog(context, isBugReport: isBugReport);

    if (!mounted) return;

    if (success == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback! 🙏'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else if (success == false) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final habitCount = (await database.getAllHabits()).length;
      final completionCount =
          (await database.select(database.habitCompletions).get()).length;
      final journalCount = (await database.getAllJournalEntries()).length;

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Data Summary'),
            content: Text(
              'Your data:\n'
              '• $habitCount habits\n'
              '• $completionCount completions\n'
              '• $journalCount journal entries',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your habits, journal entries, and progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Clear all tables in a transaction
              await database.transaction(() async {
                await database.delete(database.habitCompletions).go();
                await database.delete(database.habits).go();
                await database.delete(database.journalEntries).go();
                await database.delete(database.achievements).go();
              });

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: children.asMap().entries.map((entry) {
                final isLast = entry.key == children.length - 1;
                return Column(
                  children: [
                    entry.value,
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? AppColors.primary),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
