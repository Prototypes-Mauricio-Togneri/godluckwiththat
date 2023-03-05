import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/storage/audio_storage.dart';
import 'package:tensionnode/utils/assets.dart';

class Audio {
  static final Map<String, AudioPool> pool = {};
  static bool enabled = false;

  static Future load() async {
    enabled = await AudioStorage.load();

    _loadSound(Assets.AUDIO_SFX_AMMO1);
    _loadSound(Assets.AUDIO_SFX_AMMO2);
  }

  static Future _loadSound(String path) async {
    await FlameAudio.audioCache.load(path);
    pool[path] = await FlameAudio.createPool(
      path,
      minPlayers: 5,
      maxPlayers: 10,
    );
  }

  static void play(String path) {
    if (enabled) {
      pool[path]!.start();
    }
  }
}
