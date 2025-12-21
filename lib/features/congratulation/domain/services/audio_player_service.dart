import 'package:audioplayers/audioplayers.dart';
import 'package:japaneseapp/core/Service/FunctionService.dart';

abstract class IAudioPlayerService {
  Future<void> play(String assetPath);
  Future<void> stop();
}

class AudioPlayerService implements IAudioPlayerService{
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> play(String assetPath) async {
    print("play");

    try {
      await _audioPlayer.play(AssetSource(assetPath));
      print("play 2");
      // FunctionService fs = FunctionService();
      // await fs.setDay(context);
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      return;
    }
  }

}