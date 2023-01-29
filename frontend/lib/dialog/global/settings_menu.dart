import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/global/base_global_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class SettingsMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'settings_menu';

  const SettingsMenu(this.game);

  factory SettingsMenu.builder(BuildContext _, GameComponent game) =>
      SettingsMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseGlobalMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Audio',
              icon: Icons.volume_down,
              color: Palette.primary,
              onPressed: _onAudio,
              topPadding: 0,
            ),
            MenuButton(
              text: 'Auto save',
              icon: Icons.save,
              color: Palette.primary,
              onPressed: _onAutosave,
            ),
            MenuButton(
              text: 'Close',
              icon: Icons.close,
              color: Palette.lightGrey,
              onPressed: _closeMenu,
            ),
          ],
        ),
      ),
    );
  }

  void _onAudio() {}

  void _onAutosave() {}

  void _closeMenu() => game.closeMenu(name: SettingsMenu.NAME);
}
