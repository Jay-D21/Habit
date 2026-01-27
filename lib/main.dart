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
  await Firebase.initializeApp();

  // Initialize AWS Amplify
  await configureAmplify();

  // Initialize Drift database
  database = AppDatabase();

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();

  runApp(
    const ProviderScope(
      child: HabitTrackerApp(),
    ),
  );
}
