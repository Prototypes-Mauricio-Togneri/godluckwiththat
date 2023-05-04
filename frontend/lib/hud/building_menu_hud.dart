import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/custom_tooltip.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';

class BuildingMenuHud extends StatelessWidget {
  final GameState state;
  final Building building;

  const BuildingMenuHud({
    required this.state,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Palette.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(
              text: building.buildingType.toString(),
              size: 12,
            ),
            const VBox(10),
            Label(
              text: 'Level: ${building.level}',
              size: 12,
            ),
            const VBox(10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ImageAsset(
                  path: Assets.IMAGES_RESOURCES_VILLAGER,
                  size: 25,
                ),
                const HBox(5),
                Label(
                  text: '${building.workers}',
                  size: 12,
                ),
              ],
            ),
            if (building is Producer)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Label(
                  text:
                      '${(building as Producer).resourceType.toString()}: ${(building as Producer).productionRate} / min',
                  size: 12,
                ),
              ),
            const VBox(10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTooltip(
                  content: Label(
                    text: building.buildingType
                        .cost(building.level + 1)
                        .text('Cost'),
                    color: Palette.white,
                    size: 10,
                  ),
                  child: QuickMenuButton(
                    color: Palette.primary,
                    icon: Icons.upload,
                    size: 40,
                    onPressed: state.colony.inventory
                            .has(building.buildingType.cost(building.level + 1))
                        ? building.onUpgrade
                        : null,
                  ),
                ),
                const HBox(10),
                QuickMenuButton(
                  color: Palette.success,
                  icon: Icons.add,
                  size: 40,
                  onPressed:
                      (state.colony.hasFreeVillagers && building.canAddWorkers)
                          ? building.onAddVillager
                          : null,
                ),
                const HBox(10),
                QuickMenuButton(
                  color: Palette.error,
                  icon: Icons.remove,
                  size: 40,
                  onPressed:
                      building.hasWorkers ? building.onRemoveVillager : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuickMenuButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;
  final VoidCallback? onPressed;

  const QuickMenuButton({
    required this.color,
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (onPressed != null) ? color : Palette.lightGrey,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: size / 20,
          color: Palette.white,
        ),
      ),
      child: Material(
        color: Palette.transparent,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
              size: size / 2,
            ),
          ),
        ),
      ),
    );
  }
}
