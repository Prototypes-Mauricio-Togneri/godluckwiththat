// https://jfxr.frozenfractal.com
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/services/assets.dart';

class Audio {
  static void load() {
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_BULLET);
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_LASER);
  }
}
