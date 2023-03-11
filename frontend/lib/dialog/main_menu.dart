import 'package:flutter/material.dart';
import 'package:tensionplanet/dialog/base_menu.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/platform/clipboard_text.dart';
import 'package:tensionplanet/storage/saved_matches_storage.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

class MainMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'main_menu';

  const MainMenu(this.game);

  factory MainMenu.builder(BuildContext _, GameComponent game) =>
      MainMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.primary,
              onPressed: _onContinue,
              topPadding: 0,
            ),
            /*MenuButton(
              text: 'Load',
              icon: Icons.upload,
              color: Palette.primary,
              onPressed: _onLoad,
            ),*/
            MenuButton(
              text: 'Save',
              icon: Icons.save,
              color: Palette.primary,
              onPressed: _onSave,
            ),
            MenuButton(
              text: 'Settings',
              icon: Icons.settings,
              color: Palette.primary,
              onPressed: _onSettings,
            ),
            /*MenuButton(
              text: 'Info',
              icon: Icons.info,
              color: Palette.primary,
              onPressed: _onInfo,
            ),*/
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    _closeMenu();
  }

  /*void _onLoad() {
    _closeMenu();
  }*/

  void _onSave() {
    final JsonMatch jsonMatch = game.state.getMatch(game.camera);
    SavedMatchesStorage.save(jsonMatch.toJsonString());
    ClipboardText().copy(jsonMatch.toJsonString());
    _closeMenu();
  }

  void _onSettings() => game.openSettingsMenu();

  /*void _onInfo() {
    game.openMenu(name: InfoMenu.NAME);
  }*/

  void _closeMenu() => game.closeMenu(
        name: MainMenu.NAME,
        resumeGame: true,
      );
}
