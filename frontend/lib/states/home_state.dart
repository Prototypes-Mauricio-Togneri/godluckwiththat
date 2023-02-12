import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/storage/saved_matches_storage.dart';

class HomeState extends BaseState {
  @override
  Future onLoad() async {
    final bool hasSavedMatch = await SavedMatchesStorage.hasSavedMatch();

    if (hasSavedMatch) {
      final String json = await SavedMatchesStorage.load();
      final JsonMatch jsonMatch = JsonMatch.fromString(json);
      Navigation.matchScreen(jsonMatch);
    } else {
      //final String xml =
      //    Environment.isProd ? Constants.EMPTY_MATCH : Constants.TEST_MATCH;
      final JsonMatch jsonMatch = JsonMatch.fromString(Constants.EMPTY_MATCH);
      Navigation.matchScreen(jsonMatch);
    }
  }

  void onContinue() {}

  void onSettings() {}

  void onInfo() {}
}
