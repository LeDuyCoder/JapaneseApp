import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';

class GoogleTTSService {
  final AudioPlayer _player = AudioPlayer();

  GoogleTTSService();

  String _hashText(String text) {
    return sha1.convert(utf8.encode(text)).toString();
  }

  Future<Directory> _getCacheDir() async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory("${tempDir.path}/tts_cache");
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  Future<bool> speak(
      String text, {
        String language = "ja-JP",
        String voiceName = "ja-JP-Neural2-B",
        String nativeName = "日本語女性B",
        String sampleRateHertz = "24000",
      }) async {
    if (text.trim().isEmpty) {
      print("⚠️ Text is empty, cannot generate TTS.");
      return false;
    }

    final cacheDir = await _getCacheDir();
    final filename = "${_hashText(text)}.mp3";
    final filePath = "${cacheDir.path}/$filename";

    if (await File(filePath).exists()) {
      print("Playing from cache: $filePath");
      await _player.play(DeviceFileSource(filePath));
      return true;
    }

    try {
      print("🔊 Generating TTS for: $text");

      // Sử dụng cấu hình đơn giản hơn
      final ttsParams = TtsParamsGoogle(
        text: text,
        voice: VoiceGoogle(
          code: voiceName,
          name: voiceName,
          nativeName: nativeName,
          voiceType: "NEURAL_2", // Thay đổi từ WAVE_NET sang NEURAL_2
          gender: "FEMALE",
          locale: VoiceLocale.code(code: language),
          sampleRateHertz: sampleRateHertz,
        ),
        audioFormat: AudioOutputFormatGoogle.mp3,
        // Bỏ pitch và rate để đơn giản hóa
      );

      final ttsResponse = await TtsGoogle.convertTts(ttsParams);
      Uint8List audioBytes = ttsResponse.audio.buffer.asUint8List();

      final file = File(filePath);
      await file.writeAsBytes(audioBytes);

      await _player.play(DeviceFileSource(filePath));
      print("✅ TTS generated and played: $text");
      return true;
    } catch (e) {
      print("❌ TTS Error: $e");
      return false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> clearCache() async {
    final cacheDir = await _getCacheDir();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
      print("Cache cleared.");
    }
  }

  void dispose() {
    _player.dispose();
  }
}