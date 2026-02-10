import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/greeting_header.dart';
import 'widgets/streak_cards.dart';
import 'widgets/today_habits_section.dart';
import 'widgets/top_priority_section.dart';
import 'widgets/motivational_quote_card.dart';
import 'widgets/weekly_overview.dart';
import 'widgets/daily_progress_chart.dart';
import '../../../core/services/ad_service.dart';

/// Home screen / Dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Greeting Header
            SliverToBoxAdapter(
              child: const GreetingHeader()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0),
            ),

            // Streak Cards
            SliverToBoxAdapter(
              child: const StreakCards()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: 0.1, end: 0),
            ),

            // Motivational Quote
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: 16),
                child: MotivationalQuoteCard(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 150.ms)
                  .slideY(begin: 0.1, end: 0),
            ),

            // Top Priority Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: TopPrioritySection(),
              ),
            ),

            // Today's Habits Section
            SliverToBoxAdapter(
              child: const TodayHabitsSection()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),
            ),

            // Daily Progress Chart (Line Graph)
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: 16),
                child: DailyProgressChart(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 250.ms)
                  .slideY(begin: 0.1, end: 0),
            ),

            // Weekly Overview
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: 16),
                child: WeeklyOverview(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),
            ),

            // Banner Ad
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const BannerAdWidget()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 350.ms),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
