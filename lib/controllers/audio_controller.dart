import 'package:just_audio/just_audio.dart';

class AudioController {
  final String audio;
  late final AudioPlayer player;
  AudioController({required this.audio}) {
    player = AudioPlayer();
    player.setAsset(audio).then((_) {
      print('initalizedPlayer');
      player.setVolume(1);
    });
  }

  Future<void> play() async {
    await player.seek(Duration.zero);
    player.play().then((e) {
      // player.stop();
    });
  }
}
