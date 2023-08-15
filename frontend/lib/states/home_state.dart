import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/json/json_match.dart';
import 'package:godluckwiththat/storage/saved_matches_storage.dart';
import 'package:godluckwiththat/utils/navigation.dart';

class HomeState extends BaseState {
  @override
  Future onLoad() async {
    final bool hasSavedMatch = await SavedMatchesStorage.hasSavedMatch();

    if (hasSavedMatch) {
      final String json = await SavedMatchesStorage.load();
      final JsonMatch jsonMatch = JsonMatch.fromString(json);
      Navigation.matchScreen(jsonMatch);
    } else {
      final JsonMatch jsonMatch = JsonMatch.fromString(Constants.EMPTY_MATCH);
      Navigation.matchScreen(jsonMatch);
    }
  }

  void onContinue() {}

  void onSettings() {}

  void onInfo() {}
}
