import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/core/Config/config.dart';
import 'package:japaneseapp/core/ads/rewarded_ad_service.dart';

import 'ad_result.dart';

class RewardedAdServiceImpl implements RewardedAdService {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  @override
  Future<AdResult> show() async {
    _rewardedAd ??= await _loadAd();

    if (_rewardedAd == null) {
      return AdResult.failed;
    }

    final completer = Completer<AdResult>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) {
          completer.complete(AdResult.skipped);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) {
          completer.complete(AdResult.failed);
        }
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, __) {
        if (!completer.isCompleted) {
          completer.complete(AdResult.watched);
        }
      },
    );

    return completer.future;
  }


  Future<RewardedAd?> _loadAd() async {
    if (_isLoading) return null;

    _isLoading = true;
    final completer = Completer<RewardedAd?>();

    RewardedAd.load(
      adUnitId: Config.admodRewardId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoading = false;
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

}

