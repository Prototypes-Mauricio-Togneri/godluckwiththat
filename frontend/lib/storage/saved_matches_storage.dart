import 'package:godluckwiththat/storage/base_storage.dart';

class SavedMatchesStorage extends Storage {
  static const FIELD_SAVED_MATCH = 'saved.match';

  static Future save(String json) => Storage.setString(FIELD_SAVED_MATCH, json);

  static Future<String> load() => Storage.getString(FIELD_SAVED_MATCH, '{}');

  static Future<bool> hasSavedMatch() => Storage.contains(FIELD_SAVED_MATCH);
}
