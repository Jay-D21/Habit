import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/greeting_header.dart';
import 'widgets/streak_cards.dart';
import 'widgets/today_habits_section.dart';
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
            // Greeting + Settings gear
            SliverToBoxAdapter(
              child: const GreetingHeader().animate().fadeIn(duration: 300.ms),
            ),

            // Streak Cards
            SliverToBoxAdapter(
              child: const StreakCards()
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 50.ms),
            ),

            // Quote
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: MotivationalQuoteCard(),
              ),
            ),

            // Today's Habits
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: TodayHabitsSection()),

            // Daily Progress Chart
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: DailyProgressChart(),
              ),
            ),

            // Weekly Overview
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: WeeklyOverview(),
              ),
            ),

            // Banner Ad
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: BannerAdWidget(),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
