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

  BannerAdState({this.ad, this.isLoaded = false});
}

/// Banner Ad Notifier
class BannerAdNotifier extends Notifier<BannerAdState> {
  @override
  BannerAdState build() {
    _loadAd();
    return BannerAdState();
  }

  void _loadAd() {
    final bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner ad loaded successfully!');
          state = BannerAdState(ad: ad as BannerAd, isLoaded: true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          // Retry after 60 seconds
          Future.delayed(const Duration(seconds: 60), _loadAd);
        },
      ),
    );
    bannerAd.load();
  }

  void dispose() {
    state.ad?.dispose();
  }
}

final bannerAdProvider = NotifierProvider<BannerAdNotifier, BannerAdState>(() {
  return BannerAdNotifier();
});

/// Interstitial Ad Manager
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  void loadAd() {
    if (_isLoading || _interstitialAd != null) return;
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial ad loaded successfully!');
          _interstitialAd = ad;
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('📺 Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              loadAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Interstitial failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial ad failed to load: $error');
          _isLoading = false;
          // Retry after 60 seconds
          Future.delayed(const Duration(seconds: 60), loadAd);
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
    await _interstitialAd!.show();
    return true;
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
  static const int _habitsBeforeAd = 2;
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

    if (!adState.isLoaded || adState.ad == null) {
      return const SizedBox(height: 50); // Placeholder height
    }

    return Container(
      alignment: Alignment.center,
      width: adState.ad!.size.width.toDouble(),
      height: adState.ad!.size.height.toDouble(),
      child: AdWidget(ad: adState.ad!),
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
