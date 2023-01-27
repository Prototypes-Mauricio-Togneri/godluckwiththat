import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_global_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MainMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'main_menu';

  const MainMenu(this.game);

  factory MainMenu.builder(BuildContext _, GameComponent game) =>
      MainMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseGlobalMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.blue,
              onPressed: _onContinue,
              topPadding: 0,
            ),
            MenuButton(
              text: 'Load game',
              icon: Icons.upload,
              color: Palette.blue,
              onPressed: _onLoad,
            ),
            MenuButton(
              text: 'Save game',
              icon: Icons.save,
              color: Palette.blue,
              onPressed: _onSave,
            ),
            MenuButton(
              text: 'Settings',
              icon: Icons.settings,
              color: Palette.blue,
              onPressed: _onSettings,
            ),
            MenuButton(
              text: 'Close',
              icon: Icons.close,
              color: Palette.lightGrey,
              onPressed: _onClose,
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    _closeMenu();
  }

  void _onLoad() {
    _closeMenu();
  }

  void _onSave() {
    /*final JsonMatch jsonMatch = JsonMatch(
      version: match.version,
      id: match.id,
      map: map.json,
      resources: headquarters.jsonResources,
      patches: patches.json,
      nodes: nodes.json,
    );

    ClipboardText().copy(jsonMatch.toJsonString());*/

    _closeMenu();
  }

  void _onSettings() {
    game.openMenu(name: SettingsMenu.NAME);
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    game.closeMenu(
      name: MainMenu.NAME,
      resumeGame: true,
    );
  }
}
