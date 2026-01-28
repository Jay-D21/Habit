import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AdMob Ad Unit IDs
class AdConfig {
  // Production Ad Unit IDs
  static const String bannerAdUnitId = 'ca-app-pub-5797130278067710/5969721289';
  static const String interstitialAdUnitId =
      'ca-app-pub-5797130278067710/1883330139';
  static const String nativeAdUnitId = 'ca-app-pub-5797130278067710/9908966293';

  // Test Ad Unit IDs (uncomment for development)
  // static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  // static const String interstitialAdUnitId =
  //     'ca-app-pub-3940256099942544/1033173712';
  // static const String nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
}

/// Initialize Mobile Ads SDK
Future<void> initializeAds() async {
  await MobileAds.instance.initialize();
}

/// Provider for ad initialization status
final adsInitializedProvider = FutureProvider<bool>((ref) async {
  await MobileAds.instance.initialize();
  return true;
});

/// Banner Ad State
class BannerAdState {
  final BannerAd? ad;
  final bool isLoaded;
  final bool hasError;
  final int retryCount;
  final String? errorMessage;

  BannerAdState({
    this.ad,
    this.isLoaded = false,
    this.hasError = false,
    this.retryCount = 0,
    this.errorMessage,
  });

  BannerAdState copyWith({
    BannerAd? ad,
    bool? isLoaded,
    bool? hasError,
    int? retryCount,
    String? errorMessage,
  }) {
    return BannerAdState(
      ad: ad ?? this.ad,
      isLoaded: isLoaded ?? this.isLoaded,
      hasError: hasError ?? this.hasError,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Banner Ad Notifier with Retry Logic
class BannerAdNotifier extends Notifier<BannerAdState> {
  static const int maxRetries = 3;

  @override
  BannerAdState build() {
    _loadAd();
    return BannerAdState();
  }

  void _loadAd() {
    debugPrint(
        '🎯 Loading banner ad (attempt ${state.retryCount + 1}/$maxRetries)...');

    final bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner ad loaded successfully!');
          state = BannerAdState(
            ad: ad as BannerAd,
            isLoaded: true,
            hasError: false,
            retryCount: 0,
          );
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
              '❌ Banner ad failed to load: ${error.message} (Code: ${error.code})');
          ad.dispose();

          final newRetryCount = state.retryCount + 1;

          if (newRetryCount < maxRetries) {
            // Exponential backoff: 2s, 4s, 8s
            final delaySeconds = 2 << (newRetryCount - 1); // 2^n
            debugPrint('🔄 Retrying in ${delaySeconds}s...');

            state = state.copyWith(
              hasError: true,
              retryCount: newRetryCount,
              errorMessage: error.message,
            );

            Future.delayed(Duration(seconds: delaySeconds), _loadAd);
          } else {
            debugPrint('⛔ Max retries reached. Ad failed permanently.');
            state = state.copyWith(
              hasError: true,
              retryCount: newRetryCount,
              errorMessage: 'Failed after $maxRetries attempts',
            );
          }
        },
      ),
    );
    bannerAd.load();
  }

  /// Manual retry for user-triggered reload
  void retry() {
    debugPrint('🔄 Manual retry triggered...');
    state = BannerAdState(); // Reset state
    _loadAd();
  }

  void dispose() {
    state.ad?.dispose();
  }
}

final bannerAdProvider = NotifierProvider<BannerAdNotifier, BannerAdState>(() {
  return BannerAdNotifier();
});

/// Interstitial Ad Manager with Retry Logic
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int maxRetries = 3;

  void loadAd() {
    if (_isLoading || _interstitialAd != null) return;
    _isLoading = true;

    debugPrint(
        '🎯 Loading interstitial ad (attempt ${_retryCount + 1}/$maxRetries)...');

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial ad loaded successfully!');
          _interstitialAd = ad;
          _isLoading = false;
          _retryCount = 0; // Reset retry counter on success
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('📺 Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              loadAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Interstitial failed to show: ${error.message}');
              ad.dispose();
              _interstitialAd = null;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint(
              '❌ Interstitial ad failed to load: ${error.message} (Code: ${error.code})');
          _isLoading = false;

          if (_retryCount < maxRetries) {
            _retryCount++;
            // Exponential backoff: 2s, 4s, 8s
            final delaySeconds = 2 << (_retryCount - 1);
            debugPrint('🔄 Retrying interstitial in ${delaySeconds}s...');
            Future.delayed(Duration(seconds: delaySeconds), loadAd);
          } else {
            debugPrint('⛔ Max retries reached for interstitial ad.');
            _retryCount = 0; // Reset for next attempt later
          }
        },
      ),
    );
  }

  Future<bool> showAd() async {
    if (_interstitialAd == null) {
      debugPrint('⏳ Interstitial not ready, loading...');
      loadAd();
      return false;
    }
    debugPrint('📺 Showing interstitial ad!');
    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      debugPrint('❌ Error showing interstitial: $e');
      return false;
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}

/// Provider for interstitial ad manager
final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  final manager = InterstitialAdManager();
  manager.loadAd(); // Preload on creation
  ref.onDispose(manager.dispose);
  return manager;
});

/// Ad Frequency Manager - Controls when to show interstitial ads
/// - Shows ad after every 2 habit completions
/// - Shows ad on every 3rd or 4th app open
class AdFrequencyManager extends Notifier<AdFrequencyState> {
  static const int _habitsBeforeAd =
      3; // Increased from 2 to 3 for less intrusion
  static const int _appOpensBeforeAd = 3;

  @override
  AdFrequencyState build() {
    _loadFromPrefs();
    return AdFrequencyState();
  }

  Future<void> _loadFromPrefs() async {
    // Load persisted values on startup
    final prefs = await SharedPreferences.getInstance();
    final appOpens = prefs.getInt('ad_app_opens') ?? 0;
    state = state.copyWith(appOpenCount: appOpens);
  }

  /// Call this when a habit is completed
  Future<void> onHabitCompleted(WidgetRef ref) async {
    debugPrint('🎯 onHabitCompleted called!');
    final newCount = state.habitCompletionCount + 1;
    state = state.copyWith(habitCompletionCount: newCount);
    debugPrint('📊 Habit completion count: $newCount / $_habitsBeforeAd');

    if (newCount >= _habitsBeforeAd) {
      debugPrint('🎬 Threshold reached! Showing interstitial ad...');
      // Reset counter and show ad
      state = state.copyWith(habitCompletionCount: 0);
      await _showInterstitialAd(ref);
    }
  }

  /// Call this when app opens (in main.dart or splash)
  Future<void> onAppOpen(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.appOpenCount + 1;

    await prefs.setInt('ad_app_opens', newCount);
    state = state.copyWith(appOpenCount: newCount);

    // Show ad on 3rd, 6th, 9th... app open (every 3 opens)
    if (newCount >= _appOpensBeforeAd && newCount % _appOpensBeforeAd == 0) {
      // Small delay to let app load first
      await Future.delayed(const Duration(seconds: 2));
      await _showInterstitialAd(ref);
    }
  }

  Future<void> _showInterstitialAd(WidgetRef ref) async {
    final adManager = ref.read(interstitialAdManagerProvider);
    await adManager.showAd();
  }

  /// Manually trigger an interstitial ad
  Future<void> showInterstitialNow(WidgetRef ref) async {
    await _showInterstitialAd(ref);
  }
}

class AdFrequencyState {
  final int habitCompletionCount;
  final int appOpenCount;

  AdFrequencyState({
    this.habitCompletionCount = 0,
    this.appOpenCount = 0,
  });

  AdFrequencyState copyWith({
    int? habitCompletionCount,
    int? appOpenCount,
  }) {
    return AdFrequencyState(
      habitCompletionCount: habitCompletionCount ?? this.habitCompletionCount,
      appOpenCount: appOpenCount ?? this.appOpenCount,
    );
  }
}

final adFrequencyProvider =
    NotifierProvider<AdFrequencyManager, AdFrequencyState>(() {
  return AdFrequencyManager();
});

/// Banner Ad Widget - use this in your screens
class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adState = ref.watch(bannerAdProvider);
    final theme = Theme.of(context);

    // Successfully loaded ad
    if (adState.isLoaded && adState.ad != null) {
      return Container(
        alignment: Alignment.center,
        width: adState.ad!.size.width.toDouble(),
        height: adState.ad!.size.height.toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: AdWidget(ad: adState.ad!),
      );
    }

    // Error state - failed after max retries
    if (adState.hasError && adState.retryCount >= BannerAdNotifier.maxRetries) {
      return Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 16,
              color: theme.colorScheme.error.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Ad failed to load',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(bannerAdProvider.notifier).retry();
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Retry',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Loading or retrying state
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            adState.hasError && adState.retryCount > 0
                ? 'Retrying ad... (${adState.retryCount}/${BannerAdNotifier.maxRetries})'
                : 'Loading ad...',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Adaptive Banner Ad Widget - adapts to screen width
class AdaptiveBannerAdWidget extends ConsumerStatefulWidget {
  const AdaptiveBannerAdWidget({super.key});

  @override
  ConsumerState<AdaptiveBannerAdWidget> createState() =>
      _AdaptiveBannerAdWidgetState();
}

class _AdaptiveBannerAdWidgetState
    extends ConsumerState<AdaptiveBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      debugPrint('Unable to get adaptive banner size');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Adaptive banner failed: $error');
          ad.dispose();
        },
      ),
    );
    await _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
