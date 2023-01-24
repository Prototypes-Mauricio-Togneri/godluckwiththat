import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_dialog.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MainMenu extends StatelessWidget {
  final MyGame game;

  const MainMenu(this.game);

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
    if (!game.overlays.isActive('settings_menu')) {
      game.overlays.add('settings_menu');
    }
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    if (game.overlays.isActive('main_menu')) {
      game.overlays.remove('main_menu');
      game.resumeEngine();
    }
  }
}
