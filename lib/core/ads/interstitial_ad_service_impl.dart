import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/core/Config/config.dart';
import 'package:japaneseapp/core/ads/interstitial_ad_service.dart';

class InterstitialAdServiceImpl implements InterstitialAdService {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  @override
  Future<bool> show() async {
    _interstitialAd ??= await _loadAd();

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          },
        );

    _interstitialAd!.show();

    return completer.future;
  }

  Future<InterstitialAd?> _loadAd() async {
    if (_isLoading) return null;

    _isLoading = true;
    final completer = Completer<InterstitialAd?>();

    InterstitialAd.load(
      adUnitId: Config.admodId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          ad.setImmersiveMode(true);
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoading = false;
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }
}