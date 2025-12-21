import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/core/Config/config.dart';
import 'package:japaneseapp/core/ads/interstitial_ad_service.dart';

class InterstitialAdServiceImpl implements InterstitialAdService {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  @override
  Future<bool> show() async {
    if (_interstitialAd == null && !_isLoading) {
      await _loadAd();
    }

    if (_interstitialAd == null) {
      return false;
    }

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

  Future<void> _loadAd() async {
    _isLoading = true;

    await InterstitialAd.load(
      adUnitId: Config.admodId, // test / production id
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoading = false;
        },
      ),
    );
  }
}