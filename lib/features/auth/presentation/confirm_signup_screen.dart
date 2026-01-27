import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/services/aws_auth_service.dart';

class ConfirmSignupScreen extends ConsumerStatefulWidget {
  final String username;

  const ConfirmSignupScreen({
    super.key,
    required this.username,
  });

  @override
  ConsumerState<ConfirmSignupScreen> createState() =>
      _ConfirmSignupScreenState();
}

class _ConfirmSignupScreenState extends ConsumerState<ConfirmSignupScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_codeController.text.length < 6) return;

    setState(() => _isLoading = true);

    final success = await ref.read(awsAuthProvider.notifier).confirmSignUp(
          username: widget.username,
          confirmationCode: _codeController.text,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account confirmed! Please sign in.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/login');
    } else {
      if (mounted) {
        final error = ref.read(awsAuthProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Confirmation failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _resendCode() async {
    await ref
        .read(awsAuthProvider.notifier)
        .resendConfirmationCode(widget.username);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code resent. Check your email.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.headlineMedium,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Verification Code',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'We sent a code to your email. Enter it below to verify your account.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Pinput Field
              Center(
                child: Pinput(
                  length: 6,
                  controller: _codeController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onCompleted: (_) => _confirm(),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Verify Button
              FilledButton(
                onPressed: _isLoading ? null : _confirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify Account'),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Resend Code
              TextButton(
                onPressed: _resendCode,
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
