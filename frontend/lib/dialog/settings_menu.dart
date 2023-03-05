import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/storage/audio_storage.dart';
import 'package:tensionnode/utils/audio.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class SettingsMenu extends StatelessWidget {
  final GameComponent game;
  final SettingsMenuState state;

  static const String NAME = 'settings_menu';

  const SettingsMenu(this.game, this.state);

  factory SettingsMenu.builder(BuildContext _, GameComponent game) =>
      SettingsMenu(
        game,
        SettingsMenuState(),
      );

  @override
  Widget build(BuildContext context) {
    return BaseMenu(
      child: IntrinsicWidth(
        child: StateProvider<SettingsMenuState>(
          state: state,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Label(text: 'AUDIO'),
                  const Spacer(),
                  Switch(
                    value: Audio.enabled,
                    onChanged: state.onAudioChange,
                  ),
                ],
              ),
              /*MenuButton(
              text: 'Auto save',
              icon: Icons.save,
              color: Palette.primary,
              onPressed: _onAutosave,
            ),*/
              MenuButton(
                text: 'Close',
                icon: Icons.close,
                color: Palette.lightGrey,
                onPressed: _closeMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //void _onAutosave() {}

  void _closeMenu() => game.closeMenu(name: SettingsMenu.NAME);
}

class SettingsMenuState extends BaseState {
  void onAudioChange(bool value) {
    Audio.enabled = value;
    AudioStorage.save(value);
    notify();
  }
}
