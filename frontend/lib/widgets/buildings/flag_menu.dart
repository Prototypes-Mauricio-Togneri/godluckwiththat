import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/routed_resource.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class FlagMenu extends StatelessWidget {
  final GameComponent game;
  final Flag flag;

  const FlagMenu(this.game, this.flag);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Label(
            text: flag.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '${flag.location.i}, ${flag.location.j}',
            align: TextAlign.center,
          ),
          const VBox(10),
          for (final RoutedResource resource in flag.queue)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Label(
                text: resource.resource.toString().toUpperCase(),
              ),
            ),
          const VBox(10),
          MenuButton(
            text: 'Center',
            icon: Icons.filter_tilt_shift,
            color: Palette.primary,
            onPressed: () => _onCenter(flag),
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

class ResourceIndicator extends StatelessWidget {
  final String image;
  final int amount;

  const ResourceIndicator({
    required this.image,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('images/$image'),
          ),
          const Spacer(),
          Label(
            text: '$amount',
            size: 12,
          ),
        ],
      ),
    );
  }
}
