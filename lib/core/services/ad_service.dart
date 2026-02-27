import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ══════════════════════════════════════════════════════════════
// AD CONFIGURATION — All 7 Production Ad Unit IDs
// ══════════════════════════════════════════════════════════════

class AdConfig {
  static const String appOpenAdUnitId =
      'ca-app-pub-5797130278067710/5422496140';
  static const String bannerAdUnitId = 'ca-app-pub-5797130278067710/5969721289';
  static const String interstitialAdUnitId =
      'ca-app-pub-5797130278067710/1883330139';
  static const String nativeAdUnitId1 =
      'ca-app-pub-5797130278067710/6029505387';
  static const String nativeAdUnitId2 =
      'ca-app-pub-5797130278067710/9908966293';
  static const String rewardedAdUnitId =
      'ca-app-pub-5797130278067710/7733469291';
  static const String rewardedInterstitialAdUnitId =
      'ca-app-pub-5797130278067710/8743298637';
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

// ══════════════════════════════════════════════════════════════
// 1. APP OPEN AD — Shows when app returns to foreground (4h cooldown)
// ══════════════════════════════════════════════════════════════

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoadingAd = false;
  DateTime? _lastShowTime;
  static const Duration _cooldown = Duration(hours: 4);

  void loadAd() {
    if (_isLoadingAd || _appOpenAd != null) return;
    _isLoadingAd = true;

    debugPrint('🚀 Loading App Open ad...');
    AppOpenAd.load(
      adUnitId: AdConfig.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ App Open ad loaded');
          _appOpenAd = ad;
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ App Open ad failed: ${error.message}');
          _isLoadingAd = false;
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (_isShowingAd) return;
    if (_appOpenAd == null) {
      loadAd();
      return;
    }

    // Enforce 4-hour cooldown
    if (_lastShowTime != null) {
      final elapsed = DateTime.now().difference(_lastShowTime!);
      if (elapsed < _cooldown) {
        debugPrint(
            '⏳ App Open ad cooldown: ${_cooldown.inHours - elapsed.inHours}h remaining');
        return;
      }
    }

    _isShowingAd = true;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _lastShowTime = DateTime.now();
        loadAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    debugPrint('📺 Showing App Open ad');
    _appOpenAd!.show();
  }

  void dispose() {
    _appOpenAd?.dispose();
  }
}

final appOpenAdManagerProvider = Provider<AppOpenAdManager>((ref) {
  final manager = AppOpenAdManager();
  manager.loadAd();
  ref.onDispose(manager.dispose);
  return manager;
});

// ══════════════════════════════════════════════════════════════
// 2. BANNER AD — Passive, bottom of screens (existing)
// ══════════════════════════════════════════════════════════════

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed: ${error.message}');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox(width: double.infinity, height: 50);
    }
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 3. INTERSTITIAL AD — Every 3rd habit completion / 3rd app open
// ══════════════════════════════════════════════════════════════

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  void loadAd() {
    if (_isLoading || _interstitialAd != null) return;
    _isLoading = true;

    debugPrint('🎯 Loading interstitial ad (attempt ${_retryCount + 1})...');
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial ad loaded');
          _interstitialAd = ad;
          _isLoading = false;
          _retryCount = 0;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial failed: ${error.message}');
          _isLoading = false;
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = 2 << (_retryCount - 1);
            Future.delayed(Duration(seconds: delay), loadAd);
          } else {
            _retryCount = 0;
          }
        },
      ),
    );
  }

  Future<bool> showAd() async {
    if (_interstitialAd == null) {
      loadAd();
      return false;
    }
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

final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  final manager = InterstitialAdManager();
  manager.loadAd();
  ref.onDispose(manager.dispose);
  return manager;
});

// ══════════════════════════════════════════════════════════════
// 4. REWARDED AD — User opts in for "Double XP" bonus
// ══════════════════════════════════════════════════════════════

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  bool get isReady => _rewardedAd != null;

  void loadAd() {
    if (_isLoading || _rewardedAd != null) return;
    _isLoading = true;

    debugPrint('🎁 Loading rewarded ad...');
    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded ad loaded');
          _rewardedAd = ad;
          _isLoading = false;
          _retryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded ad failed: ${error.message}');
          _isLoading = false;
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = 2 << (_retryCount - 1);
            Future.delayed(Duration(seconds: delay), loadAd);
          } else {
            _retryCount = 0;
          }
        },
      ),
    );
  }

  /// Shows the rewarded ad. Returns the reward item if watched, null if not.
  Future<RewardItem?> showAd() async {
    if (_rewardedAd == null) {
      loadAd();
      return null;
    }

    RewardItem? earnedReward;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadAd(); // Preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🏆 User earned reward: ${reward.amount} ${reward.type}');
        earnedReward = reward;
      },
    );

    return earnedReward;
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}

final rewardedAdManagerProvider = Provider<RewardedAdManager>((ref) {
  final manager = RewardedAdManager();
  manager.loadAd();
  ref.onDispose(manager.dispose);
  return manager;
});

// ══════════════════════════════════════════════════════════════
// 5. REWARDED INTERSTITIAL — Every 5 min of active use
// ══════════════════════════════════════════════════════════════

class RewardedInterstitialAdManager {
  RewardedInterstitialAd? _ad;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  void loadAd() {
    if (_isLoading || _ad != null) return;
    _isLoading = true;

    debugPrint('🎬 Loading rewarded interstitial...');
    RewardedInterstitialAd.load(
      adUnitId: AdConfig.rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded interstitial loaded');
          _ad = ad;
          _isLoading = false;
          _retryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded interstitial failed: ${error.message}');
          _isLoading = false;
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = 2 << (_retryCount - 1);
            Future.delayed(Duration(seconds: delay), loadAd);
          } else {
            _retryCount = 0;
          }
        },
      ),
    );
  }

  Future<bool> showAd() async {
    if (_ad == null) {
      loadAd();
      return false;
    }

    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        loadAd();
      },
    );

    await _ad!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🏆 Rewarded interstitial reward: ${reward.amount}');
      },
    );
    return true;
  }

  void dispose() {
    _ad?.dispose();
  }
}

final rewardedInterstitialAdManagerProvider =
    Provider<RewardedInterstitialAdManager>((ref) {
  final manager = RewardedInterstitialAdManager();
  manager.loadAd();
  ref.onDispose(manager.dispose);
  return manager;
});

// ══════════════════════════════════════════════════════════════
// 6. NATIVE AD WIDGET — Inline ads that blend with content
// ══════════════════════════════════════════════════════════════

class NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final double height;

  const NativeAdWidget({
    super.key,
    this.adUnitId = AdConfig.nativeAdUnitId1,
    this.height = 120,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Native ad failed: ${error.message}');
          ad.dispose();
          _nativeAd = null;
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.transparent,
      ),
    );
    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: widget.height,
      child: AdWidget(ad: _nativeAd!),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// AD FREQUENCY MANAGER — Controls when to show interstitial ads
// Triggers: every 3 habit completions, every 3rd app open
// ══════════════════════════════════════════════════════════════

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

class AdFrequencyManager extends Notifier<AdFrequencyState> {
  static const int _habitsBeforeAd = 3;
  static const int _appOpensBeforeAd = 3;

  @override
  AdFrequencyState build() {
    _loadFromPrefs();
    return AdFrequencyState();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final appOpens = prefs.getInt('ad_app_opens') ?? 0;
    state = state.copyWith(appOpenCount: appOpens);
  }

  /// Call when a habit is completed
  Future<void> onHabitCompleted() async {
    final newCount = state.habitCompletionCount + 1;
    state = state.copyWith(habitCompletionCount: newCount);
    debugPrint('📊 Habit completions: $newCount / $_habitsBeforeAd');

    if (newCount >= _habitsBeforeAd) {
      state = state.copyWith(habitCompletionCount: 0);
      await _showInterstitialAd();
    }
  }

  /// Call when app opens
  Future<void> onAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.appOpenCount + 1;
    await prefs.setInt('ad_app_opens', newCount);
    state = state.copyWith(appOpenCount: newCount);

    if (newCount >= _appOpensBeforeAd && newCount % _appOpensBeforeAd == 0) {
      await Future.delayed(const Duration(seconds: 2));
      await _showInterstitialAd();
    }
  }

  Future<void> _showInterstitialAd() async {
    final adManager = ref.read(interstitialAdManagerProvider);
    await adManager.showAd();
  }

  Future<void> showInterstitialNow() async {
    await _showInterstitialAd();
  }
}

final adFrequencyProvider =
    NotifierProvider<AdFrequencyManager, AdFrequencyState>(() {
  return AdFrequencyManager();
});

// ══════════════════════════════════════════════════════════════
// SESSION TIMER — Triggers rewarded interstitial every 5 min
// ══════════════════════════════════════════════════════════════

class SessionAdTimer extends Notifier<int> {
  static const int _minutesBetweenAds = 5;

  @override
  int build() {
    _startTimer();
    return 0;
  }

  void _startTimer() {
    Future.delayed(const Duration(minutes: _minutesBetweenAds), () {
      _onTimerFired();
    });
  }

  void _onTimerFired() {
    state = state + 1;
    debugPrint(
        '⏱️ Session timer fired (${state}x). Showing rewarded interstitial...');

    final adManager = ref.read(rewardedInterstitialAdManagerProvider);
    adManager.showAd();

    // Restart the timer for next interval
    _startTimer();
  }
}

final sessionAdTimerProvider = NotifierProvider<SessionAdTimer, int>(() {
  return SessionAdTimer();
});
