import 'package:audioplayers/audioplayers.dart';

class AlarmService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> startAlarm() async {
    await _player.play(AssetSource('sounds/alarm.mp3'));
  }

  Future<void> stopAlarm() async {
    await _player.stop();
  }
}