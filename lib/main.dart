import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app.dart';
import 'core/database/database.dart';
import 'core/services/aws_auth_service.dart';

/// Global Drift database instance
late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }

  // Initialize AWS Amplify
  try {
    await configureAmplify();
    debugPrint('✅ AWS Amplify configured successfully');
  } catch (e) {
    debugPrint('❌ AWS Amplify configuration failed: $e');
  }

  // Initialize Drift database
  database = AppDatabase();
  debugPrint('✅ Database initialized');

  // Initialize Mobile Ads SDK
  try {
    final initStatus = await MobileAds.instance.initialize();
    debugPrint('✅ AdMob SDK initialized successfully');
    debugPrint('📊 AdMob Adapter Status: ${initStatus.adapterStatuses}');
  } catch (e) {
    debugPrint('❌ AdMob initialization failed: $e');
    debugPrint('⚠️  Ads may not load properly');
  }

  runApp(
    const ProviderScope(
      child: HabitTrackerApp(),
    ),
  );
}
