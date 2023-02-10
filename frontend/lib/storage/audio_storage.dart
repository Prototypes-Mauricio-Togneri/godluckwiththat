import 'package:tensionnode/storage/base_storage.dart';

class AudioStorage extends Storage {
  static const FIELD_AUDIO_ENABLED = 'audio.enabled';

  static Future save(bool value) => Storage.setBool(FIELD_AUDIO_ENABLED, value);

  static Future<bool> load() => Storage.getBool(FIELD_AUDIO_ENABLED, true);
}
