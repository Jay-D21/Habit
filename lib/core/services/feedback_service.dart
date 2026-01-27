import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

import '../../models/ModelProvider.dart' as model;

/// Service for submitting user feedback to AWS DynamoDB via AppSync
class FeedbackService {
  /// Submit feedback to AWS
  /// Returns true if successful
  static Future<bool> submitFeedback({
    required String message,
    required model.FeedbackType type,
    String? userEmail,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      // Get app version
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';

      // Get device info
      final deviceInfo = DeviceInfoPlugin();
      String platformName = 'Unknown';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        platformName =
            'Android ${androidInfo.version.release} (${androidInfo.model})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        platformName =
            'iOS ${iosInfo.systemVersion} (${iosInfo.utsname.machine})';
      } else {
        platformName = Platform.operatingSystem;
      }

      final feedback = model.Feedback(
        message: message,
        type: type,
        userEmail: userEmail,
        userName: user.username,
        appVersion: appVersion,
        platform: platformName,
        status: 'new',
      );

      final request = ModelMutations.create(feedback);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        debugPrint('Failed to submit feedback: ${response.errors}');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Failed to submit feedback: $e');
      return false;
    }
  }
}

/// Show feedback dialog and submit to AWS
Future<bool?> showFeedbackDialog(BuildContext context,
    {bool isBugReport = false}) {
  final controller = TextEditingController();
  final emailController = TextEditingController();
  model.FeedbackType selectedType =
      isBugReport ? model.FeedbackType.bugReport : model.FeedbackType.feedback;

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(isBugReport ? 'Report a Problem' : 'Send Feedback'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feedback Type Selector
                DropdownButtonFormField<model.FeedbackType>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: model.FeedbackType.feedback,
                      child: Text('💬 General Feedback'),
                    ),
                    DropdownMenuItem(
                      value: model.FeedbackType.bugReport,
                      child: Text('🐛 Bug Report'),
                    ),
                    DropdownMenuItem(
                      value: model.FeedbackType.featureRequest,
                      child: Text('💡 Feature Request'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Email (optional)
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Your Email (optional)',
                    hintText: 'For follow-up',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Message
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: selectedType == model.FeedbackType.bugReport
                        ? 'Describe the problem'
                        : 'Your feedback',
                    hintText: selectedType == model.FeedbackType.bugReport
                        ? 'What happened? What did you expect?'
                        : 'Tell us what you think...',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  maxLength: 1000,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your feedback')),
                  );
                  return;
                }

                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final success = await FeedbackService.submitFeedback(
                  message: controller.text.trim(),
                  type: selectedType,
                  userEmail: emailController.text.trim().isNotEmpty
                      ? emailController.text.trim()
                      : null,
                );

                if (context.mounted) {
                  Navigator.pop(context); // Close loading
                  Navigator.pop(context, success); // Close dialog
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    ),
  );
}
