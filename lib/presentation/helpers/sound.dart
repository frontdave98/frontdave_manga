import 'package:audioplayers/audioplayers.dart';

void playSound() async {
  final player = AudioPlayer();
  await player.setSource(AssetSource('sound.mp3'));
  await player.resume();
}
