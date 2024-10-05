import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/windows/buildings_window.dart';

class GameState extends BaseGameState {
  GameState() {
    colony.setState(this);
  }

  void onPause() {
    print('Pause');
  }

  // TODO(momo): all buildings management in a single window
  void onMenuBuildings() => BuildingsWindow.show(this);

  // TODO(momo): all workers management in a single window
  void onMenuPopulation() {
    print('Menu Population');
  }

  // TODO(momo): all resources management in a single window
  void onMenuResearch() {
    print('Menu Research');
  }

  void onMenuReligion() {
    print('Menu Religion');
  }

  void onMenuMilitary() {
    print('Menu Military');
  }

  void onMenuMarket() {
    print('Menu Market');
  }

  void onUpcoming() {
    print('Upcoming');
  }

  void onCleanAllEvents() {
    print('Clean All Events');
  }

  void onEventSelected() {
    print('Event');
  }

  void onEventClosed() {
    print('Event Closed');
  }
}
