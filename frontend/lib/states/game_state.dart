import 'package:flutter/widgets.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/widgets/blocks/headquarters_block.dart';
import 'package:godluckwiththat/windows/base_window.dart';
import 'package:godluckwiththat/windows/buildings_window.dart';

class GameState extends BaseGameState {
  Widget? currentWindow;

  GameState() {
    colony.setState(this);
  }

  bool get hasWindow => currentWindow != null;

  void onPause() {
    print('Pause');
  }

  void onMenuHeadquarters() => _showWindow(BaseWindow(
        title: colony.headquarters.type.name,
        state: this,
        child: HeadquartersBlock(this),
      ));

  void onMenuBuildings() => _showWindow(BuildingsWindow(this));

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

  void _showWindow(Widget widget) {
    currentWindow = widget;
    notify();
  }

  void closeWindow() {
    currentWindow = null;
    notify();
  }
}
