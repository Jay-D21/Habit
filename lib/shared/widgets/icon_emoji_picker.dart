import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Full-screen Icon & Emoji picker with tabs, search, and categorized grids.
/// Returns null if dismissed, or the selected string (emoji or icon code point).
class IconEmojiPicker extends StatefulWidget {
  final String? initialValue;
  const IconEmojiPicker({super.key, this.initialValue});

  @override
  State<IconEmojiPicker> createState() => _IconEmojiPickerState();
}

class _IconEmojiPickerState extends State<IconEmojiPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context, _selected),
        ),
        title: TabBar(
          controller: _tabController,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.5),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          isScrollable: false,
          tabs: const [Tab(text: 'Icon'), Tab(text: 'Emoji')],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a search term',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _IconGrid(
                  searchQuery: _searchQuery,
                  selected: _selected,
                  onSelect: (v) {
                    setState(() => _selected = v);
                    Navigator.pop(context, v);
                  },
                ),
                _EmojiGrid(
                  searchQuery: _searchQuery,
                  selected: _selected,
                  onSelect: (v) {
                    setState(() => _selected = v);
                    Navigator.pop(context, v);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────── Icon Grid with categories ───────────

class _IconGrid extends StatelessWidget {
  final String searchQuery;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _IconGrid({
    required this.searchQuery,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = _filteredIconCategories(searchQuery);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 12),
            Text(cat.name,
                style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: cat.icons.map((entry) {
                final code = 'icon:${entry.icon.codePoint}';
                final isSelected = selected == code;
                return GestureDetector(
                  onTap: () => onSelect(code),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Icon(entry.icon,
                        size: 22,
                        color: isSelected
                            ? AppColors.primary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.7)),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ─────────── Emoji Grid with categories ───────────

class _EmojiGrid extends StatelessWidget {
  final String searchQuery;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _EmojiGrid({
    required this.searchQuery,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = _filteredEmojiCategories(searchQuery);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 12),
            Text(cat.name,
                style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: cat.emojis.map((entry) {
                final isSelected = selected == entry.emoji;
                return GestureDetector(
                  onTap: () => onSelect(entry.emoji),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child:
                        Text(entry.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ─────────── Data ───────────

class _NamedIcon {
  final IconData icon;
  final String label;
  const _NamedIcon(this.icon, this.label);
}

class _IconCategory {
  final String name;
  final List<_NamedIcon> icons;
  const _IconCategory(this.name, this.icons);
}

class _NamedEmoji {
  final String emoji;
  final String label;
  const _NamedEmoji(this.emoji, this.label);
}

class _EmojiCategory {
  final String name;
  final List<_NamedEmoji> emojis;
  const _EmojiCategory(this.name, this.emojis);
}

List<_IconCategory> _filteredIconCategories(String query) {
  final all = _allIconCategories;
  if (query.isEmpty) return all;
  return all
      .map((cat) => _IconCategory(
          cat.name, cat.icons.where((i) => i.label.contains(query)).toList()))
      .where((cat) => cat.icons.isNotEmpty)
      .toList();
}

List<_EmojiCategory> _filteredEmojiCategories(String query) {
  final all = _allEmojiCategories;
  if (query.isEmpty) return all;
  return all
      .map((cat) => _EmojiCategory(
          cat.name, cat.emojis.where((e) => e.label.contains(query)).toList()))
      .where((cat) => cat.emojis.isNotEmpty)
      .toList();
}

// ─── Icon data ───

final _allIconCategories = [
  const _IconCategory('Activities', [
    _NamedIcon(Icons.camera_alt_outlined, 'camera'),
    _NamedIcon(Icons.podcasts_outlined, 'podcast'),
    _NamedIcon(Icons.call_outlined, 'call'),
    _NamedIcon(Icons.download_outlined, 'download'),
    _NamedIcon(Icons.anchor_outlined, 'anchor'),
    _NamedIcon(Icons.chair_outlined, 'chair'),
    _NamedIcon(Icons.backpack_outlined, 'backpack'),
    _NamedIcon(Icons.bathtub_outlined, 'bath'),
    _NamedIcon(Icons.videogame_asset_outlined, 'gaming'),
    _NamedIcon(Icons.menu_book_outlined, 'book'),
    _NamedIcon(Icons.auto_stories_outlined, 'reading'),
    _NamedIcon(Icons.book_outlined, 'study'),
    _NamedIcon(Icons.code_outlined, 'code'),
    _NamedIcon(Icons.gps_fixed_outlined, 'focus'),
    _NamedIcon(Icons.view_module_outlined, 'module'),
    _NamedIcon(Icons.psychology_outlined, 'brain'),
    _NamedIcon(Icons.headphones_outlined, 'headphones'),
    _NamedIcon(Icons.piano_outlined, 'piano'),
    _NamedIcon(Icons.music_note_outlined, 'music'),
    _NamedIcon(Icons.palette_outlined, 'art'),
    _NamedIcon(Icons.brush_outlined, 'paint'),
    _NamedIcon(Icons.photo_camera_outlined, 'photo'),
    _NamedIcon(Icons.nightlife_outlined, 'nightlife'),
    _NamedIcon(Icons.restaurant_outlined, 'cooking'),
  ]),
  const _IconCategory('Health & Wellness', [
    _NamedIcon(Icons.self_improvement_outlined, 'yoga'),
    _NamedIcon(Icons.spa_outlined, 'spa'),
    _NamedIcon(Icons.local_hospital_outlined, 'hospital'),
    _NamedIcon(Icons.medical_services_outlined, 'medical'),
    _NamedIcon(Icons.monitor_heart_outlined, 'heart'),
    _NamedIcon(Icons.water_drop_outlined, 'water'),
    _NamedIcon(Icons.local_pharmacy_outlined, 'medicine'),
    _NamedIcon(Icons.bed_outlined, 'sleep'),
    _NamedIcon(Icons.hotel_outlined, 'rest'),
    _NamedIcon(Icons.emoji_food_beverage_outlined, 'tea'),
    _NamedIcon(Icons.coffee_outlined, 'coffee'),
    _NamedIcon(Icons.local_dining_outlined, 'food'),
  ]),
  const _IconCategory('Sports & Fitness', [
    _NamedIcon(Icons.fitness_center_outlined, 'gym'),
    _NamedIcon(Icons.sports_basketball_outlined, 'basketball'),
    _NamedIcon(Icons.sports_soccer_outlined, 'soccer'),
    _NamedIcon(Icons.sports_tennis_outlined, 'tennis'),
    _NamedIcon(Icons.sports_cricket_outlined, 'cricket'),
    _NamedIcon(Icons.sports_golf_outlined, 'golf'),
    _NamedIcon(Icons.pool_outlined, 'swimming'),
    _NamedIcon(Icons.directions_run_outlined, 'running'),
    _NamedIcon(Icons.directions_walk_outlined, 'walking'),
    _NamedIcon(Icons.directions_bike_outlined, 'cycling'),
    _NamedIcon(Icons.hiking_outlined, 'hiking'),
    _NamedIcon(Icons.skateboarding_outlined, 'skateboarding'),
    _NamedIcon(Icons.surfing_outlined, 'surfing'),
    _NamedIcon(Icons.snowboarding_outlined, 'snowboarding'),
  ]),
  const _IconCategory('Work & Productivity', [
    _NamedIcon(Icons.laptop_mac_outlined, 'laptop'),
    _NamedIcon(Icons.desktop_mac_outlined, 'desktop'),
    _NamedIcon(Icons.edit_note_outlined, 'notes'),
    _NamedIcon(Icons.task_alt_outlined, 'task'),
    _NamedIcon(Icons.assignment_outlined, 'assignment'),
    _NamedIcon(Icons.schedule_outlined, 'schedule'),
    _NamedIcon(Icons.work_outline, 'work'),
    _NamedIcon(Icons.business_center_outlined, 'business'),
    _NamedIcon(Icons.school_outlined, 'school'),
    _NamedIcon(Icons.account_balance_outlined, 'bank'),
    _NamedIcon(Icons.savings_outlined, 'savings'),
    _NamedIcon(Icons.trending_up_outlined, 'growth'),
  ]),
  const _IconCategory('Home & Lifestyle', [
    _NamedIcon(Icons.home_outlined, 'home'),
    _NamedIcon(Icons.cleaning_services_outlined, 'cleaning'),
    _NamedIcon(Icons.local_laundry_service_outlined, 'laundry'),
    _NamedIcon(Icons.yard_outlined, 'garden'),
    _NamedIcon(Icons.pets_outlined, 'pets'),
    _NamedIcon(Icons.child_care_outlined, 'childcare'),
    _NamedIcon(Icons.family_restroom_outlined, 'family'),
    _NamedIcon(Icons.shopping_cart_outlined, 'shopping'),
    _NamedIcon(Icons.local_grocery_store_outlined, 'grocery'),
    _NamedIcon(Icons.commute_outlined, 'commute'),
    _NamedIcon(Icons.church_outlined, 'prayer'),
    _NamedIcon(Icons.volunteer_activism_outlined, 'volunteer'),
  ]),
  const _IconCategory('Social', [
    _NamedIcon(Icons.people_alt_outlined, 'people'),
    _NamedIcon(Icons.group_outlined, 'group'),
    _NamedIcon(Icons.forum_outlined, 'chat'),
    _NamedIcon(Icons.emoji_emotions_outlined, 'emotions'),
    _NamedIcon(Icons.handshake_outlined, 'handshake'),
    _NamedIcon(Icons.celebration_outlined, 'celebration'),
    _NamedIcon(Icons.card_giftcard_outlined, 'gift'),
    _NamedIcon(Icons.videocam_outlined, 'videocall'),
  ]),
];

// ─── Emoji data ───

final _allEmojiCategories = [
  const _EmojiCategory('Health & Wellness', [
    _NamedEmoji('💧', 'water'),
    _NamedEmoji('🥗', 'salad'),
    _NamedEmoji('🍎', 'apple'),
    _NamedEmoji('🥦', 'broccoli'),
    _NamedEmoji('🧘', 'yoga'),
    _NamedEmoji('💊', 'medicine'),
    _NamedEmoji('🩺', 'doctor'),
    _NamedEmoji('❤️', 'heart'),
    _NamedEmoji('🫀', 'anatomical heart'),
    _NamedEmoji('🧠', 'brain'),
    _NamedEmoji('😴', 'sleep'),
    _NamedEmoji('💤', 'zzz'),
    _NamedEmoji('🛏️', 'bed'),
    _NamedEmoji('🪥', 'toothbrush'),
    _NamedEmoji('🚿', 'shower'),
  ]),
  const _EmojiCategory('Fitness & Sports', [
    _NamedEmoji('🏃', 'running'),
    _NamedEmoji('💪', 'muscle'),
    _NamedEmoji('🚴', 'cycling'),
    _NamedEmoji('🏋️', 'weight'),
    _NamedEmoji('🤸', 'cartwheel'),
    _NamedEmoji('⚽', 'soccer'),
    _NamedEmoji('🏊', 'swimming'),
    _NamedEmoji('🎾', 'tennis'),
    _NamedEmoji('🧗', 'climbing'),
    _NamedEmoji('🚶', 'walking'),
    _NamedEmoji('🏀', 'basketball'),
    _NamedEmoji('⚾', 'baseball'),
    _NamedEmoji('🏈', 'football'),
    _NamedEmoji('🎯', 'target'),
    _NamedEmoji('🥊', 'boxing'),
    _NamedEmoji('🏆', 'trophy'),
    _NamedEmoji('🥇', 'medal'),
  ]),
  const _EmojiCategory('Mindfulness & Self-care', [
    _NamedEmoji('🙏', 'pray'),
    _NamedEmoji('😌', 'relieved'),
    _NamedEmoji('🌸', 'flower'),
    _NamedEmoji('✨', 'sparkle'),
    _NamedEmoji('🌙', 'moon'),
    _NamedEmoji('☀️', 'sun'),
    _NamedEmoji('🌅', 'sunrise'),
    _NamedEmoji('🔮', 'crystal'),
    _NamedEmoji('🕯️', 'candle'),
    _NamedEmoji('🧘', 'meditate'),
    _NamedEmoji('🌿', 'herb'),
    _NamedEmoji('🌈', 'rainbow'),
  ]),
  const _EmojiCategory('Learning & Productivity', [
    _NamedEmoji('📚', 'books'),
    _NamedEmoji('📖', 'book'),
    _NamedEmoji('✍️', 'writing'),
    _NamedEmoji('📝', 'memo'),
    _NamedEmoji('💻', 'laptop'),
    _NamedEmoji('🧮', 'abacus'),
    _NamedEmoji('🎓', 'graduation'),
    _NamedEmoji('🔬', 'microscope'),
    _NamedEmoji('📊', 'chart'),
    _NamedEmoji('📋', 'clipboard'),
    _NamedEmoji('✅', 'check'),
    _NamedEmoji('⏰', 'alarm'),
  ]),
  const _EmojiCategory('Creativity', [
    _NamedEmoji('🎨', 'art'),
    _NamedEmoji('🎵', 'music'),
    _NamedEmoji('🎸', 'guitar'),
    _NamedEmoji('📷', 'camera'),
    _NamedEmoji('🎬', 'movie'),
    _NamedEmoji('✏️', 'pencil'),
    _NamedEmoji('🎭', 'theater'),
    _NamedEmoji('🎹', 'piano'),
    _NamedEmoji('🎤', 'microphone'),
    _NamedEmoji('🪡', 'sewing'),
    _NamedEmoji('🖌️', 'paintbrush'),
    _NamedEmoji('📸', 'photo'),
  ]),
  const _EmojiCategory('Finance', [
    _NamedEmoji('💰', 'money'),
    _NamedEmoji('📈', 'chart up'),
    _NamedEmoji('💵', 'dollar'),
    _NamedEmoji('🏦', 'bank'),
    _NamedEmoji('💳', 'card'),
    _NamedEmoji('🧾', 'receipt'),
    _NamedEmoji('💎', 'gem'),
    _NamedEmoji('🪙', 'coin'),
  ]),
  const _EmojiCategory('Social', [
    _NamedEmoji('👋', 'wave'),
    _NamedEmoji('🤝', 'handshake'),
    _NamedEmoji('💬', 'chat'),
    _NamedEmoji('📞', 'phone'),
    _NamedEmoji('👨‍👩‍👧', 'family'),
    _NamedEmoji('🎁', 'gift'),
    _NamedEmoji('🎉', 'party'),
    _NamedEmoji('👥', 'group'),
    _NamedEmoji('🙌', 'hands'),
  ]),
  const _EmojiCategory('Travel & Places', [
    _NamedEmoji('🌍', 'earth'),
    _NamedEmoji('🌏', 'globe'),
    _NamedEmoji('🗺️', 'map'),
    _NamedEmoji('🏔️', 'mountain'),
    _NamedEmoji('🏖️', 'beach'),
    _NamedEmoji('🏕️', 'camping'),
    _NamedEmoji('🌴', 'palm'),
    _NamedEmoji('🗼', 'tower'),
    _NamedEmoji('✈️', 'plane'),
    _NamedEmoji('🚗', 'car'),
  ]),
  const _EmojiCategory('Home & Lifestyle', [
    _NamedEmoji('☕', 'coffee'),
    _NamedEmoji('🧹', 'broom'),
    _NamedEmoji('🏠', 'home'),
    _NamedEmoji('🪴', 'plant'),
    _NamedEmoji('🐕', 'dog'),
    _NamedEmoji('🐱', 'cat'),
    _NamedEmoji('👶', 'baby'),
    _NamedEmoji('🍳', 'cooking'),
  ]),
];

/// Helper: render the stored icon/emoji value as a widget.
/// Values starting with "icon:" are Material icon code points.
/// Everything else is treated as an emoji string.
Widget buildIconEmojiDisplay(String value, {double size = 28, Color? color}) {
  if (value.startsWith('icon:')) {
    final codePoint = int.tryParse(value.substring(5));
    if (codePoint != null) {
      return Icon(
        IconData(codePoint, fontFamily: 'MaterialIcons'),
        size: size,
        color: color,
      );
    }
  }
  return Text(value, style: TextStyle(fontSize: size));
}
