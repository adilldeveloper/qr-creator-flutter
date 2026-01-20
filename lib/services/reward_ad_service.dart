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
      return 'ca-app-pub-4767222875229256/6162173887'; // iOS
    } else {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android test
    }
  }

  void load({
    required VoidCallback onLoaded,
    required VoidCallback onFailed,
  }) {
    if (_isLoading || _rewardedAd != null) return;

    _isLoading = true;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          onLoaded();
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
          _isLoading = false;
          onFailed();
        },
      ),
    );
  }

  void show({
    required VoidCallback onRewardEarned,
    required VoidCallback onAdClosed,
  }) {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        ad.dispose();
        _rewardedAd = null;
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (_, __) {
        ad.dispose();
        _rewardedAd = null;
        onAdClosed();
      },
    );

    ad.show(
      onUserEarnedReward: (_, __) {
        onRewardEarned();
      },
    );
  }
}
