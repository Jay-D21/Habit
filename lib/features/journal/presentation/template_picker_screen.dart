import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../data/models/journal_template.dart';
import '../data/journal_templates_data.dart';

class TemplatePickerScreen extends ConsumerStatefulWidget {
  const TemplatePickerScreen({super.key});

  @override
  ConsumerState<TemplatePickerScreen> createState() =>
      _TemplatePickerScreenState();
}

class _TemplatePickerScreenState extends ConsumerState<TemplatePickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<JournalTemplate> _filteredTemplates = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredTemplates = journalTemplates;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredTemplates = journalTemplates;
      } else {
        _filteredTemplates = journalTemplates.where((template) {
          return template.name.toLowerCase().contains(_searchQuery) ||
              template.description.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _onTemplateSelected(JournalTemplate template) {
    context.push(
      '/journal/template-details',
      extra: template,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Group templates by category for the "All Templates" section
    final templatesByCategory =
        <JournalTemplateCategory, List<JournalTemplate>>{};
    for (var template in _filteredTemplates) {
      if (!templatesByCategory.containsKey(template.category)) {
        templatesByCategory[template.category] = [];
      }
      templatesByCategory[template.category]!.add(template);
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search templates...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),

          // Recommended Section (Only show if not searching)
          if (_searchQuery.isEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, 0,
                    AppTheme.spacingLg, AppTheme.spacingSm),
                child: Text(
                  'RECOMMENDED FOR YOU',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLg),
                  children: [
                    _FeatureCard(
                      template: journalTemplates
                          .firstWhere((t) => t.id == 'daily_reflection'),
                      onTap: () => _onTemplateSelected(journalTemplates
                          .firstWhere((t) => t.id == 'daily_reflection')),
                      imageUrl:
                          'assets/images/daily_reflection.png', // Placeholder, we'll use gradient/icon
                      gradientColors: const [
                        Color(0xFF4FACFE),
                        Color(0xFF00F2FE)
                      ],
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    _FeatureCard(
                      template: journalTemplates
                          .firstWhere((t) => t.id == 'manifestation_369'),
                      onTap: () => _onTemplateSelected(journalTemplates
                          .firstWhere((t) => t.id == 'manifestation_369')),
                      imageUrl: 'assets/images/morning_routine.png',
                      gradientColors: const [
                        Color(0xFFFA709A),
                        Color(0xFFFEE140)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingXl)),
          ],

          // All Templates Section
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Text(
                _searchQuery.isEmpty ? 'ALL TEMPLATES' : 'SEARCH RESULTS',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingSm)),

          // List of templates grouped by category (or flat list if searching)
          if (_searchQuery.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final template = _filteredTemplates[index];
                  return _TemplateListTile(
                      template: template,
                      onTap: () => _onTemplateSelected(template));
                },
                childCount: _filteredTemplates.length,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = templatesByCategory.keys.elementAt(index);
                  final templates = templatesByCategory[category]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppTheme.spacingLg,
                            AppTheme.spacingMd,
                            AppTheme.spacingLg,
                            AppTheme.spacingSm),
                        child: Text(
                          _getCategoryName(category),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      ...templates.map((t) => _TemplateListTile(
                          template: t, onTap: () => _onTemplateSelected(t))),
                    ],
                  );
                },
                childCount: templatesByCategory.keys.length,
              ),
            ),

          const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXxl)),
        ],
      ),
    );
  }

  String _getCategoryName(JournalTemplateCategory category) {
    switch (category) {
      case JournalTemplateCategory.daily:
        return 'Daily';
      case JournalTemplateCategory.weekly:
        return 'Weekly & Monthly';
      case JournalTemplateCategory.wellness:
        return 'Wellness & Emotional';
      case JournalTemplateCategory.productivity:
        return 'Productivity';
      case JournalTemplateCategory.manifestation:
        return 'Manifestation';
      case JournalTemplateCategory.gratitude:
        return 'Gratitude';
      case JournalTemplateCategory.reflection:
        return 'Reflection';
    }
  }
}

class _FeatureCard extends StatelessWidget {
  final JournalTemplate template;
  final VoidCallback onTap;
  final String imageUrl;
  final List<Color> gradientColors;

  const _FeatureCard({
    required this.template,
    required this.onTap,
    required this.imageUrl,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative shapes
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                template.icon,
                size: 140,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    template.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      template.estimatedDuration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateListTile extends StatelessWidget {
  final JournalTemplate template;
  final VoidCallback onTap;

  const _TemplateListTile({required this.template, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: template.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(template.icon, color: template.color, size: 24),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        template.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
