import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/overlay/base_overlay.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/primary_button.dart';

class MainOverlay extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'main_overlay';

  const MainOverlay(this.game);

  factory MainOverlay.builder(BuildContext _, GameComponent game) =>
      MainOverlay(game);

  @override
  Widget build(BuildContext context) {
    return BaseOverlay(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.primary,
              onPressed: _onContinue,
            ),
            /*MenuButton(
              text: 'Load',
              icon: Icons.upload,
              color: Palette.primary,
              onPressed: _onLoad,
            ),*/
            PrimaryButton(
              text: 'Save',
              icon: Icons.save,
              color: Palette.primary,
              onPressed: _onSave,
            ),
            PrimaryButton(
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
    /*final JsonMatch jsonMatch = game.state.getMatch(game.camera);
    SavedMatchesStorage.save(jsonMatch.toJsonString());
    ClipboardText().copy(jsonMatch.toJsonString());*/
    _closeMenu();
  }

  void _onSettings() {}

  /*void _onInfo() {
    game.openMenu(name: InfoMenu.NAME);
  }*/

  void _closeMenu() {}
}
