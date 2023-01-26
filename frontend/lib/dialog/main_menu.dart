import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_dialog.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/game/game.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MainMenu extends StatelessWidget {
  final MyGame game;

  static const String NAME = 'main_menu';

  const MainMenu(this.game);

  factory MainMenu.builder(BuildContext _, MyGame game) => MainMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
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
    _closeMenu();
  }

  void _onSettings() {
    game.openMenu(SettingsMenu.NAME);
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    game.closeMenu(MainMenu.NAME, true);
  }
}
