import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tensionnode/dialog/base_dialog.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class SettingsMenu extends StatefulWidget {
  final MyGame game;

  const SettingsMenu(this.game);

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
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
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Audio',
              icon: Icons.volume_down,
              color: Palette.blue,
              onPressed: _onVolume,
              topPadding: 0,
            ),
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
                size: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onVolume() {
    _closeMenu();
  }

  void _onClose() {
    _closeMenu();
  }

  void _closeMenu() {
    if (widget.game.overlays.isActive('settings_menu')) {
      widget.game.overlays.remove('settings_menu');
    }
  }
}
