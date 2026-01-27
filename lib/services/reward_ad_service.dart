import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdService {
  static final RewardAdService _instance = RewardAdService._internal();
  factory RewardAdService() => _instance;
  RewardAdService._internal();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  String get _adUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-4767222875229256/6162173887'; // iOS test
    } else {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android test
    }
  }

  /// Preload ad silently (call this early)
  void preload() {
    if (_isLoading || _rewardedAd != null) return;

    _isLoading = true;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(
        nonPersonalizedAds: true, // 🔒 FORCE non-personalized ads
      ),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );

  }

  /// Try showing ad → fallback if unavailable
  void showIfAvailable({
    required VoidCallback onComplete,
  }) {
    final ad = _rewardedAd;

    if (ad == null) {
      // ❌ No ad → continue immediately
      onComplete();
      preload(); // try loading next time
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        ad.dispose();
        _rewardedAd = null;
        onComplete();
        preload(); // prepare next ad
      },
      onAdFailedToShowFullScreenContent: (_, __) {
        ad.dispose();
        _rewardedAd = null;
        onComplete();
        preload();
      },
    );

    ad.show(
      onUserEarnedReward: (_, __) {},
    );
  }
}
