import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/widgets/blocks/headquarters_block.dart';
import 'package:godluckwiththat/windows/base_window.dart';
import 'package:godluckwiththat/windows/building_detail_window.dart';
import 'package:godluckwiththat/windows/buildings_window.dart';

class GameState extends BaseGameState {
  GameState() {
    colony.setState(this);
  }

  void onPause() {
    print('Pause');
  }

  void onMenuHeadquarters() => BaseWindow.show(BuildingDetailWindow(
        title: colony.headquarters.type.name,
        child: HeadquartersBlock(this),
      ));

  void onMenuBuildings() => BuildingsWindow.show(this);

  // TODO(momo): all research management in a single window
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

  void onUpcomingSelected(Upcoming upcoming) =>
      colony.onUpcomingSelected(upcoming);

  void onCleanAllEvents() => colony.onAllEventsClosed();

  void onEventSelected(Event event) => colony.onEventSelected(event);

  void onEventClosed(Event event) => colony.onEventClosed(event);
}
