import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/drive_backup_service.dart';
import '../../core/services/ad_service.dart';

/// Main scaffold with minimalist bottom navigation bar
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driveBackupServiceProvider).autoBackupOrSync();
      ref.read(adFrequencyProvider.notifier).onAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

// ───────────── Nav Item Config ─────────────
class _NavConfig {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;

  const _NavConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });
}

const _navItems = [
  _NavConfig(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
    path: '/home',
  ),
  _NavConfig(
    icon: Icons.timer_outlined,
    activeIcon: Icons.timer_rounded,
    label: 'Focus',
    path: '/focus',
  ),
  _NavConfig(
    icon: Icons.book_outlined,
    activeIcon: Icons.book_rounded,
    label: 'Journal',
    path: '/journal',
  ),
  _NavConfig(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    label: 'Stats',
    path: '/analytics',
  ),
  _NavConfig(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    label: 'Settings',
    path: '/settings',
  ),
];

// ───────────── Bottom Nav Bar ──────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final matchIndex =
        _navItems.indexWhere((item) => location.startsWith(item.path));
    return matchIndex >= 0 ? matchIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.borderDark.withValues(alpha: 0.3)
                : AppColors.borderLight.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = i == currentIndex;

              return _NavItem(
                icon: isSelected ? item.activeIcon : item.icon,
                label: item.label,
                isSelected: isSelected,
                onTap: () => context.go(item.path),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ───────────── Single Nav Item ─────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? AppColors.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pill indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 32 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            // Label
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
