// https://jfxr.frozenfractal.com
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/services/assets.dart';

class Audio {
  static final Map<String, AudioPool> pool = {};

  static Future load() async {
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_BULLET);
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_LASER);

    pool[Assets.AUDIO_SFX_BULLET] = await _createPool(Assets.AUDIO_SFX_BULLET);
    pool[Assets.AUDIO_SFX_LASER] = await _createPool(Assets.AUDIO_SFX_LASER);
  }

  static Future<AudioPool> _createPool(String path) => FlameAudio.createPool(
        path,
        minPlayers: 5,
        maxPlayers: 10,
      );

  static void play(String path) => pool[path]!.start();
}
