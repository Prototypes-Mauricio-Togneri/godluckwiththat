import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/build/build_version.dart';
import 'package:tensionnode/dialog/base_dialog.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onLoad;
  final VoidCallback onSave;
  final VoidCallback onSettings;

  const MainMenu._(
    this.onContinue,
    this.onLoad,
    this.onSave,
    this.onSettings,
  );

  static void show({
    required VoidCallback onContinue,
    required VoidCallback onLoad,
    required VoidCallback onSave,
    required VoidCallback onSettings,
  }) =>
      BaseDialog.show(
        widget: MainMenu._(
          onContinue,
          onLoad,
          onSave,
          onSettings,
        ),
        name: 'main_menu',
      );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Palette.black,
            borderRadius: BorderRadius.circular(5),
          ),
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
                const VBox(10),
                const Center(
                  child: Label(
                    text: 'v$BUILD_VERSION',
                    color: Palette.white,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    Navigation.pop();
    onContinue();
  }

  void _onLoad() {
    Navigation.pop();
    onLoad();
  }

  void _onSave() {
    Navigation.pop();
    onSave();
  }

  void _onSettings() {
    Navigation.pop();
    onSettings();
  }
}
