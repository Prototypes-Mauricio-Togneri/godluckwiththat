import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tensionnode/dialog/base_dialog.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class MainMenu extends StatefulWidget {
  final MyGame game;

  const MainMenu._(this.game);

  static void show({
    required MyGame game,
  }) {
    game.pauseEngine();

    BaseDialog.show(
      widget: MainMenu._(game),
      name: 'main_menu',
    );
  }

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String version = '';

  @override
  void initState() {
    super.initState();
    Delayed.post(_getVersion);
  }

  Future _getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = 'v ${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      game: widget.game,
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
                const VBox(30),
                MenuButton(
                  text: 'Close',
                  icon: Icons.close,
                  color: Palette.lightGrey,
                  onPressed: _onClose,
                ),
                const VBox(10),
                Center(
                  child: Label(
                    text: version,
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
    _closeMenu();
  }

  void _onLoad() {
    _closeMenu();
  }

  void _onSave() {
    _closeMenu();
  }

  void _onSettings() {
    _closeMenu();
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    Navigation.pop();
    widget.game.resumeEngine();
  }
}
