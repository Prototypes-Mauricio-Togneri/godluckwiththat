import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/village.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Village> villages = [];
  late Village currentVillage;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;
  }

  void addVillages(List<Village> list) {
    villages.addAll(list);
    currentVillage = list[0];
  }

  void setLoaded() {
    loaded = true;
    notify();
  }

  void update(double dt) {
    totalTimeElapsed += dt;
    refreshTimeout += dt;
    print(totalTimeElapsed);

    if (refreshTimeout > 1) {
      refreshTimeout--;
      notify();
    }
  }
}
