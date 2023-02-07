import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/storage/saved_matches_storage.dart';

class HomeState extends BaseState {
  Future onLoadMatch() async {
    final bool hasSavedMatch = await SavedMatchesStorage.hasSavedMatch();

    if (hasSavedMatch) {
      
    } else {
      Navigation.matchScreen();
    }
  }

  void onSettings() {}

  void onInfo() {}
}
