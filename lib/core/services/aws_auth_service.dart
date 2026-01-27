import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amplify_api/amplify_api.dart';

import '../../amplifyconfiguration.dart';

/// Initialize Amplify - call this in main.dart before runApp
Future<void> configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    // Removed modelProvider as it was reported as undefined parameter
    final api = AmplifyAPI();
    await Amplify.addPlugins([auth, api]);
    await Amplify.configure(amplifyconfig);
    debugPrint('Amplify configured successfully');
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify was already configured');
  } catch (e) {
    debugPrint('Error configuring Amplify: $e');
  }
}

/// AWS Auth State
class AwsAuthState {
  final AuthUser? user;
  final bool isSignedIn;
  final bool isLoading;
  final String? error;

  const AwsAuthState({
    this.user,
    this.isSignedIn = false,
    this.isLoading = false,
    this.error,
  });

  AwsAuthState copyWith({
    AuthUser? user,
    bool? isSignedIn,
    bool? isLoading,
    String? error,
  }) {
    return AwsAuthState(
      user: user ?? this.user,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// AWS Auth Notifier using Cognito
class AwsAuthNotifier extends Notifier<AwsAuthState> {
  @override
  AwsAuthState build() {
    _checkCurrentUser();
    return const AwsAuthState(isLoading: true);
  }

  Future<void> _checkCurrentUser() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        state = AwsAuthState(user: user, isSignedIn: true);
      } else {
        state = const AwsAuthState(isSignedIn: false);
      }
    } catch (e) {
      state = const AwsAuthState(isSignedIn: false);
    }
  }

  /// Sign up with username and password
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      debugPrint('Attempting signup for: $username with email: $email');

      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );

      debugPrint(
          'Signup result: isSignUpComplete=${result.isSignUpComplete}, nextStep=${result.nextStep.signUpStep}');

      state = state.copyWith(isLoading: false);

      // Return true if signup is complete OR if we need to confirm (which means signup itself succeeded)
      // The nextStep will tell us if confirmation is needed
      if (result.isSignUpComplete) {
        return true;
      }

      // If we need to confirm sign up, that means signup was successful
      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp) {
        return true;
      }

      // Any other case, check if it's a valid step that means signup worked
      return true; // SignUp API call succeeded
    } on AuthException catch (e) {
      debugPrint('Signup AuthException: ${e.message}');
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      debugPrint('Signup error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Confirm sign up with verification code
  Future<bool> confirmSignUp({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      state = state.copyWith(isLoading: false);
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  /// Sign in with username and password
  Future<bool> signIn({
    required String username,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        state = AwsAuthState(user: user, isSignedIn: true);
        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  /// Sign in with Google (Web UI)
  Future<bool> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await Amplify.Auth.signInWithWebUI(
        provider: AuthProvider.google,
      );

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        state = AwsAuthState(user: user, isSignedIn: true);
        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } on AuthException catch (e) {
      if (e.message.contains('cancelled')) {
        // User cancelled
        state = state.copyWith(isLoading: false);
        return false;
      }
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Sign in with Phone OTP (Custom Auth / Passwordless)
  /// This initiates the sign-in flow and sends an OTP to the phone number.
  Future<bool> signInWithPhoneOTP({required String phoneNumber}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // For Cognito, phone number sign-in with OTP uses Custom Auth flow or
      // the standard sign-in with phone as the username if configured.
      // Since we don't have a passwordless setup, we'll use the standard flow
      // with a temporary password approach, OR we could use signInWithWebUI.
      //
      // For now, let's just attempt a custom challenge flow.
      // If Cognito is configured for passwordless, this will trigger SMS.

      final result = await Amplify.Auth.signIn(
        username: phoneNumber,
        options: const SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
            authFlowType: AuthenticationFlowType.customAuthWithSrp,
          ),
        ),
      );

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        state = AwsAuthState(user: user, isSignedIn: true);
        return true;
      }

      // Check if we need to confirm with OTP
      if (result.nextStep.signInStep ==
              AuthSignInStep.confirmSignInWithCustomChallenge ||
          result.nextStep.signInStep ==
              AuthSignInStep.confirmSignInWithSmsMfaCode) {
        state = state.copyWith(isLoading: false);
        return true; // Navigate to OTP screen
      }

      state =
          state.copyWith(isLoading: false, error: 'Unexpected sign-in step');
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Confirm phone sign-in with OTP code
  Future<bool> confirmPhoneSignIn({required String otpCode}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: otpCode,
      );

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        state = AwsAuthState(user: user, isSignedIn: true);
        return true;
      }

      state =
          state.copyWith(isLoading: false, error: 'OTP verification failed');
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      await Amplify.Auth.signOut();
      state = const AwsAuthState(isSignedIn: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  /// Resend confirmation code
  Future<void> resendConfirmationCode(String username) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: username);
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message);
    }
  }

  /// Reset password - initiate
  Future<bool> resetPassword(String username) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await Amplify.Auth.resetPassword(username: username);
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  /// Reset password - confirm with code
  Future<bool> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }
}

/// Provider for AWS auth state
final awsAuthProvider = NotifierProvider<AwsAuthNotifier, AwsAuthState>(() {
  return AwsAuthNotifier();
});

/// Provider for checking if user is signed in with AWS
final isAwsSignedInProvider = Provider<bool>((ref) {
  return ref.watch(awsAuthProvider).isSignedIn;
});
