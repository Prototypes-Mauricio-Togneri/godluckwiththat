import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';
import 'package:tensionnode/widgets/menu_button.dart';

class HeadquartersMenu extends StatelessWidget {
  final GameComponent game;
  final Headquarters headquarters;

  const HeadquartersMenu(this.game, this.headquarters);

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
            text: headquarters.type.name.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
          Label(
            text: '${headquarters.location.i}, ${headquarters.location.j}',
            align: TextAlign.center,
          ),
          const VBox(10),
          Row(
            children: [
              ResourceIndicator(
                image: Assets.IMAGES_RESOURCES_TIMBER,
                amount: headquarters.inventory.timber,
              ),
              const HBox(15),
              ResourceIndicator(
                image: Assets.IMAGES_RESOURCES_WOOD,
                amount: headquarters.inventory.wood,
              ),
              const HBox(15),
              ResourceIndicator(
                image: Assets.IMAGES_RESOURCES_STONE,
                amount: headquarters.inventory.stone,
              ),
            ],
          ),
          const VBox(10),
          MenuButton(
            text: 'Center',
            icon: Icons.filter_tilt_shift,
            color: Palette.primary,
            onPressed: () => _onCenter(headquarters),
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
          Label(text: '$amount'),
        ],
      ),
    );
  }
}
