import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tensionplanet/dialog/base_menu.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';

class InfoOverlay extends StatefulWidget {
  final GameComponent game;

  static const String NAME = 'info_overlay';

  const InfoOverlay(this.game);

  factory InfoOverlay.builder(BuildContext _, GameComponent game) =>
      InfoOverlay(game);

  @override
  State<InfoOverlay> createState() => _InfoOverlayState();
}

class _InfoOverlayState extends State<InfoOverlay> {
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
    return BaseMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Changelog',
              icon: Icons.article,
              color: Palette.primary,
              onPressed: _onChangelog,
              topPadding: 0,
            ),
            MenuButton(
              text: 'Help',
              icon: Icons.help,
              color: Palette.primary,
              onPressed: _onHelp,
            ),
            MenuButton(
              text: 'Suggestions',
              icon: Icons.tips_and_updates,
              color: Palette.primary,
              onPressed: _onSuggestions,
            ),
            MenuButton(
              text: 'Report Bug',
              icon: Icons.bug_report,
              color: Palette.primary,
              onPressed: _onReportBug,
            ),
            MenuButton(
              text: 'Credits',
              icon: Icons.auto_awesome,
              color: Palette.primary,
              onPressed: _onCredits,
            ),
            MenuButton(
              text: 'Close',
              icon: Icons.close,
              color: Palette.lightGrey,
              onPressed: _closeMenu,
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

  void _onChangelog() {}

  void _onHelp() {}

  void _onSuggestions() {}

  void _onReportBug() {}

  void _onCredits() {}

  void _closeMenu() => widget.game.closeMenu(name: InfoOverlay.NAME);
}
