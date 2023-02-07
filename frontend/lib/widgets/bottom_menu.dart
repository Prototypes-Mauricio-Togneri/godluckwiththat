import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class BottomMenu extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const BottomMenu(this.game, this.state);

  @override
  Widget build(BuildContext context) {
    if (game.paused) {
      return const Empty();
    } else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Palette.grey,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (game.constructMode)
                ConstructMenu(game)
              else if (game.isSelected(Mine))
                MineMenu(
                  game,
                  game.selectedNode(),
                )
              else if (game.isSelected(Turret))
                TurretMenu(
                  game,
                  game.selectedNode(),
                )
              else if (game.isInSpecialMode)
                CancelMenu(game),
              FixedButtons(game),
            ],
          ),
        ),
      );
    }
  }
}

class FixedButtons extends StatelessWidget {
  final GameComponent game;

  const FixedButtons(this.game);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomMenuButton(
          icon: Icons.menu,
          color: Palette.lightGrey,
          onClick: game.openMainMenu,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.construction,
          color: Palette.lightGrey,
          onClick: game.enableConstructMode,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.delete,
          color: Palette.lightGrey,
          onClick: game.enableDestroyingMode,
        ),
        const HBox(10),
        BottomMenuButton(
          icon: Icons.remove_red_eye,
          color: Palette.lightGrey,
          onClick: game.onShowDetails,
        ),
      ],
    );
  }
}

class ConstructMenu extends StatelessWidget {
  final GameComponent game;

  const ConstructMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: 'Build'.toUpperCase(),
              align: TextAlign.center,
            ),
            const VBox(5),
            MenuButton(
              text: 'Red Mine',
              icon: Icons.center_focus_strong,
              color: Palette.resourceRed,
              onPressed: () => _onBuild(MineSpec.mine_red),
            ),
            MenuButton(
              text: 'Green Mine',
              icon: Icons.center_focus_strong,
              color: Palette.resourceGreen,
              onPressed: () => _onBuild(MineSpec.mine_green),
            ),
            MenuButton(
              text: 'Blue Mine',
              icon: Icons.center_focus_strong,
              color: Palette.resourceBlue,
              onPressed: () => _onBuild(MineSpec.mine_blue),
            ),
            MenuButton(
              text: 'Light turret',
              icon: Icons.radio_button_checked,
              color: Palette.turretLight,
              onPressed: () => _onBuild(TurretSpec.turret_light),
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

  void _onBuild(FixedNodeSpec spec) {
    game.enableBuildingMode(spec);
  }

  void _closeMenu() => game.disableConstructMode();
}

class MineMenu extends StatelessWidget {
  final GameComponent game;
  final Mine mine;

  const MineMenu(this.game, this.mine);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: mine.spec.type.name,
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: '${mine.i}, ${mine.j}',
              align: TextAlign.center,
            ),
            const VBox(10),
            MenuButton(
              text: 'Center',
              icon: Icons.filter_tilt_shift,
              color: Palette.primary,
              onPressed: () => _onCenter(mine),
            ),
            MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.error,
              onPressed: _onDestroy,
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

  void _onCenter(Node node) => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class TurretMenu extends StatelessWidget {
  final GameComponent game;
  final Turret turret;

  const TurretMenu(this.game, this.turret);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: turret.spec.type.name,
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: '${turret.i}, ${turret.j}',
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: 'Shots fired: ${turret.shotsFired}',
              align: TextAlign.center,
            ),
            const VBox(10),
            Label(
              text: 'Kills: ${turret.kills}',
              align: TextAlign.center,
            ),
            const VBox(10),
            MenuButton(
              text: 'Center',
              icon: Icons.filter_tilt_shift,
              color: Palette.primary,
              onPressed: () => _onCenter(turret),
            ),
            MenuButton(
              text: 'Destroy',
              icon: Icons.delete,
              color: Palette.error,
              onPressed: _onDestroy,
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

  void _onCenter(Node node) => game.centerMap(node.position);

  void _onDestroy() {
    final Node node = game.selectedNode();
    node.destroy();
    _closeMenu();
  }

  void _closeMenu() => game.unselectNode();
}

class CancelMenu extends StatelessWidget {
  final GameComponent game;

  const CancelMenu(this.game);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.error,
            minimumSize: const Size(0, 45),
          ),
          onPressed: game.onCancelOperation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.close,
                size: 20,
              ),
              const HBox(10),
              Label(text: 'Cancel'.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onClick;

  const BottomMenuButton({
    required this.icon,
    required this.color,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onClick,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}
