import 'package:flutter/material.dart';
import 'models/journal_template.dart';
import '../../../../app/theme/app_colors.dart';

List<JournalTemplate> get journalTemplates => [
      // ────────── DAILY ──────────
      const JournalTemplate(
        id: 'daily_reflection',
        name: 'Daily Reflection',
        description: 'Review your day, what went well, and what to improve.',
        longDescription:
            'End your day with clarity and peace. This guided reflection helps you process daily events, celebrate small wins, and learn from challenges, setting you up for a better tomorrow.',
        category: JournalTemplateCategory.daily,
        icon: Icons.wb_sunny_rounded,
        color: AppColors.primary,
        titleTemplate: 'Daily Reflection',
        estimatedDuration: '5 min',
        prompts: [
          'What was the highlight of your day?',
          'What is one thing you learned today?',
          'What is one thing you could have done better?',
          'How are you feeling right now?',
        ],
        keyResults: [
          JournalTemplateKeyResult(
              icon: Icons.visibility_rounded,
              label: 'Clarity',
              description: 'Gain perspective on events'),
          JournalTemplateKeyResult(
              icon: Icons.nightlight_round,
              label: 'Results',
              description: 'Sleep better with a clear mind'),
          JournalTemplateKeyResult(
              icon: Icons.trending_up_rounded,
              label: 'Growth',
              description: 'Learn from daily experiences'),
          JournalTemplateKeyResult(
              icon: Icons.mood_rounded,
              label: 'Mood',
              description: 'Track emotional patterns'),
        ],
        expectations: [
          'Reduced stress and anxiety',
          'Better memory of daily events',
          'Increased self-awareness',
        ],
        timeline: [
          JournalTemplateTimelineItem(
              dayRange: 'Day 1-7',
              title: 'Building the Habit',
              description: 'Start small. Even one sentence is enough.'),
          JournalTemplateTimelineItem(
              dayRange: 'Day 8-21',
              title: 'Deepening Insight',
              description: 'You start noticing patterns in your behavior.'),
          JournalTemplateTimelineItem(
              dayRange: 'Day 22+',
              title: 'Mastery',
              description: 'Reflection becomes a natural part of your day.'),
        ],
      ),
      const JournalTemplate(
        id: 'morning_intention',
        name: 'Morning Intention',
        description: 'Set a positive tone and clear goals for the day ahead.',
        longDescription:
            'Start your day with purpose. Define your main focus and how you want to feel, rather than just reacting to what happens.',
        category: JournalTemplateCategory.daily,
        icon: Icons.coffee_rounded,
        color: Color(0xFFFF9500), // Orange
        titleTemplate: 'Morning Intention',
        estimatedDuration: '3 min',
        prompts: [
          'What is your main focus for today?',
          'How do you want to feel at the end of the day?',
          'What is one small thing you can do for yourself today?',
          'I am grateful for...',
        ],
        keyResults: [
          JournalTemplateKeyResult(
              icon: Icons.track_changes_rounded,
              label: 'Focus',
              description: 'Prioritize what matters'),
          JournalTemplateKeyResult(
              icon: Icons.energy_savings_leaf_rounded,
              label: 'Energy',
              description: 'Start with motivation'),
        ],
      ),
      const JournalTemplate(
        id: 'evening_wind_down',
        name: 'Evening Wind Down',
        description: 'Clear your mind and prepare for a restful sleep.',
        category: JournalTemplateCategory.daily,
        icon: Icons.bedtime_rounded,
        color: Color(0xFF5856D6), // Indigo
        titleTemplate: 'Evening Wind Down',
        estimatedDuration: '5 min',
        prompts: [
          'What are you ready to let go of from today?',
          'Three good things that happened today:',
          'What are you looking forward to tomorrow?',
        ],
      ),

      // ────────── GRATITUDE & MANIFESTATION ──────────
      const JournalTemplate(
        id: 'daily_gratitude',
        name: 'Daily Gratitude',
        description: 'Shift your mindset by focusing on the positive.',
        category: JournalTemplateCategory.gratitude,
        icon: Icons.favorite_rounded,
        color: Color(0xFFFF2D55), // Pink/Red
        titleTemplate: 'Gratitude List',
        estimatedDuration: '3 min',
        prompts: [
          'List 3 things you are grateful for today:',
          'Who is someone that made your day better?',
          'What is a simple pleasure you enjoyed?',
        ],
      ),
      const JournalTemplate(
        id: 'manifestation_369',
        name: '3-6-9 Manifestation',
        description: 'A powerful technique to align with your desires.',
        longDescription:
            'The 3-6-9 method is a simple manifestation technique. Write your desire 3 times in the morning, 6 times in the afternoon, and 9 times at night.',
        category: JournalTemplateCategory.manifestation,
        icon: Icons.auto_awesome_rounded,
        color: Color(0xFFAF52DE), // Purple
        titleTemplate: '3-6-9 Manifestation',
        estimatedDuration: '10 min',
        prompts: [
          'Morning (3 times): Write your desire clearly.',
          'Afternoon (6 times): Write your intention.',
          'Evening (9 times): Write the outcome as if it has already happened.',
        ],
        keyResults: [
          JournalTemplateKeyResult(
              icon: Icons.star_rounded,
              label: 'Clarity',
              description: 'Define exactly what you want'),
          JournalTemplateKeyResult(
              icon: Icons.psychology_rounded,
              label: 'Focus',
              description: 'Keep your goal top of mind'),
        ],
      ),
      const JournalTemplate(
        id: 'abudance_mindset',
        name: 'Abundance Mindset',
        description: 'Attract positivity and success into your life.',
        category: JournalTemplateCategory.manifestation,
        icon: Icons.diamond_rounded,
        color: Color(0xFF00C7BE), // Teal
        titleTemplate: 'Abundance Log',
        estimatedDuration: '5 min',
        prompts: [
          'Where did you notice abundance in your life today?',
          'What limiting belief are you ready to release?',
          'I am worthy of...',
        ],
      ),

      // ────────── WEEKLY & MONTHLY ──────────
      const JournalTemplate(
        id: 'weekly_review',
        name: 'Weekly Review',
        description: 'Reflect on the past week and plan for the next one.',
        category: JournalTemplateCategory.weekly,
        icon: Icons.calendar_view_week_rounded,
        color: AppColors.secondary,
        titleTemplate: 'Weekly Review',
        estimatedDuration: '10 min',
        prompts: [
          'What were your top 3 wins this week?',
          'What challenges did you face?',
          'What is your main goal for next week?',
          'How can you make next week even better?',
        ],
      ),
      const JournalTemplate(
        id: 'monthly_reset',
        name: 'Monthly Reset',
        description: 'A fresh start. Review goals and set intentions.',
        category: JournalTemplateCategory.weekly,
        icon: Icons.calendar_month_rounded,
        color: AppColors.tertiary,
        titleTemplate: 'Monthly Reset',
        estimatedDuration: '15 min',
        prompts: [
          'What did I accomplish this month?',
          'What didn\'t go as planned?',
          'Theme for the new month:',
          'Top 3 goals for this month:',
        ],
      ),

      // ────────── WELLNESS & EMOTIONAL ──────────
      const JournalTemplate(
        id: 'anxiety_relief',
        name: 'Anxiety Relief',
        description: 'Calm your mind and process tailored emotions.',
        category: JournalTemplateCategory.wellness,
        icon: Icons.self_improvement_rounded,
        color: Color(0xFF32D6E2), // Cyan
        titleTemplate: 'Anxiety Check-in',
        estimatedDuration: '7 min',
        prompts: [
          'What is worrying you right now?',
          'Is this thought a fact or a feeling?',
          'What evidence is there that everything will be okay?',
          'Take a deep breath. What is one small step you can take?',
        ],
      ),
      const JournalTemplate(
        id: 'self_love',
        name: 'Self-Love Note',
        description: 'Be kind to yourself and boost your self-esteem.',
        category: JournalTemplateCategory.wellness,
        icon: Icons.favorite_border_rounded,
        color: Color(0xFFFF69B4), // Hot Pink
        titleTemplate: 'Note to Self',
        estimatedDuration: '5 min',
        prompts: [
          'What is one thing you love about yourself?',
          'How did you practice self-care today?',
          'Write a compassionate message to yourself:',
        ],
      ),

      // ────────── PRODUCTIVITY ──────────
      const JournalTemplate(
        id: 'brain_dump',
        name: 'Brain Dump',
        description: 'Get everything out of your head and onto paper.',
        category: JournalTemplateCategory.productivity,
        icon: Icons.psychology_rounded,
        color: Colors.grey,
        titleTemplate: 'Brain Dump',
        estimatedDuration: 'Open',
        prompts: [
          'What is on your mind? (Tasks, ideas, worries...)',
          'Sort them: Must do vs. Can wait',
        ],
      ),
      const JournalTemplate(
        id: 'goal_setting',
        name: 'SMART Goal Setting',
        description: 'Define specific, measurable, achievable goals.',
        category: JournalTemplateCategory.productivity,
        icon: Icons.flag_rounded,
        color: AppColors.success,
        titleTemplate: 'New Goal',
        estimatedDuration: '10 min',
        prompts: [
          'Specific: What exactly do you want to achieve?',
          'Measurable: How will you measure progress?',
          'Achievable: Do you have the skills/resources?',
          'Relevant: Why is this goal important?',
          'Time-bound: When is the deadline?',
        ],
      ),
    ];
