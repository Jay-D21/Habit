import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/services/aws_auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); // For future implementation
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Determine identifier based on tab
      // Note: Currently AWS Auth Service uses 'username' which maps to Cognito's preferred username or email depending on config.
      // If Phone tab is selected, we use phone OTP flow.

      if (_tabController.index == 1) {
        // Phone number OTP login
        final phoneNumber = _phoneController.text.trim();
        if (phoneNumber.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your phone number')),
          );
          setState(() => _isLoading = false);
          return;
        }

        final success =
            await ref.read(awsAuthProvider.notifier).signInWithPhoneOTP(
                  phoneNumber: phoneNumber,
                );

        setState(() => _isLoading = false);

        if (success && mounted) {
          // Navigate to OTP verification screen
          context.push('/verify-otp', extra: phoneNumber);
        } else {
          if (mounted) {
            final error = ref.read(awsAuthProvider).error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error ?? 'Failed to send OTP. Please try again.'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
        return;
      }

      // Email/Username login
      final identifier = _usernameController.text.trim();

      final success = await ref.read(awsAuthProvider.notifier).signIn(
            username: identifier,
            password: _passwordController.text,
          );

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) context.go('/home');
      } else {
        if (mounted) {
          final error = ref.read(awsAuthProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(error ?? 'Login failed. Please check your credentials.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);
    // Trigger Social Auth
    final success = await ref.read(awsAuthProvider.notifier).signInWithGoogle();

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) context.go('/home');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In canceled or failed.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _skipLogin() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 120, maxWidth: 120),
                      child: Image.asset(
                        'assets/images/loop_habit_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Title
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Sign in with your email, phone, or Google',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Tabs for Email vs Phone
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.colorScheme.onSurface,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Email / Username'),
                        Tab(text: 'Mobile Number'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  SizedBox(
                    height:
                        250, // Fixed height for form area to minimize layout shifts
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Email/Username Form
                        Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Email or Username',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email or username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppTheme.spacingLg),
                            _buildPasswordField(),
                          ],
                        ),

                        // Tab 2: Mobile Number Form (OTP-based, no password)
                        Column(
                          children: [
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                  prefixIcon: Icon(Icons.phone_rounded),
                                  border: OutlineInputBorder(),
                                  hintText: '+91 98765 43210'),
                            ),
                            const SizedBox(height: AppTheme.spacingMd),
                            Text(
                              'We will send you a one-time verification code',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Login Button
                  FilledButton(
                    onPressed: _isLoading ? null : _login,
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
                        : const Text('Sign In'),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Google Sign In Button
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _googleLogin,
                    icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),

                  // Skip Option
                  TextButton(
                    onPressed: _skipLogin,
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}
