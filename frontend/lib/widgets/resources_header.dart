import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class ResourcesHeader extends StatelessWidget {
  final GameState state;

  const ResourcesHeader(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Label(
            text: 'Day: ${state.colony.day}',
            color: Palette.black,
            size: 14,
          ),
          const Spacer(),
          Label(
            text:
                'Idle villagers: ${state.colony.freeVillagers}/${state.colony.inventory.get(ResourceType.villager)}',
            color: (state.colony.freeVillagers > 0)
                ? Palette.error
                : Palette.black,
            size: 14,
          ),
        ],
      ),
    );
  }
}
