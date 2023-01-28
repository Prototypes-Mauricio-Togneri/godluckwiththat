import 'package:flutter/material.dart';
import 'package:tensionnode/dialog/base_global_menu.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class InfoMenu extends StatelessWidget {
  final GameComponent game;

  static const String NAME = 'info_menu';

  const InfoMenu(this.game);

  factory InfoMenu.builder(BuildContext _, GameComponent game) =>
      InfoMenu(game);

  @override
  Widget build(BuildContext context) {
    return BaseGlobalMenu(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'Changelog',
              icon: Icons.article,
              color: Palette.blue,
              onPressed: _onChangelog,
              topPadding: 0,
            ),
            MenuButton(
              text: 'Help',
              icon: Icons.help,
              color: Palette.blue,
              onPressed: _onHelp,
            ),
            MenuButton(
              text: 'Suggestions',
              icon: Icons.tips_and_updates,
              color: Palette.blue,
              onPressed: _onSuggestions,
            ),
            MenuButton(
              text: 'Report Bug',
              icon: Icons.bug_report,
              color: Palette.blue,
              onPressed: _onReportBug,
            ),
            MenuButton(
              text: 'Credits',
              icon: Icons.auto_awesome,
              color: Palette.blue,
              onPressed: _onCredits,
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

  void _onChangelog() {}

  void _onHelp() {}

  void _onSuggestions() {}

  void _onReportBug() {}

  void _onCredits() {}

  void _closeMenu() => game.closeMenu(name: InfoMenu.NAME);
}
