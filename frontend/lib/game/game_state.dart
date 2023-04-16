import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/research.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  final Research research = Research();
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;
  }

  void setLoaded() {
    loaded = true;
    //notify();
  }

  void update(double dt) {
    _totalTimeElapsed += dt;
    print(_totalTimeElapsed);
  }
}
