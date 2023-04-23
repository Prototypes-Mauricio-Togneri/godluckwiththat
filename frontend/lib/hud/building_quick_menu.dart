import 'package:flutter/material.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class BuildingQuickMenu extends StatelessWidget {
  final Colony colony;
  final Building building;
  final double size;

  const BuildingQuickMenu({
    required this.colony,
    required this.building,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Palette.black,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 10,
                right: 10,
              ),
              child: Label(
                text: building.buildingType.toString(),
                size: 12,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Palette.black,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 10,
                right: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text: 'Level: ${building.level}',
                    size: 12,
                  ),
                  Label(
                    text: 'Workers: ${building.workers}',
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                JustTheTooltip(
                  backgroundColor: Palette.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  content: Container(
                    color: Palette.grey,
                    padding: const EdgeInsets.all(10),
                    child: const Label(
                      text: 'Cost:\n100 wood\n50 stone',
                      color: Palette.white,
                      size: 10,
                    ),
                  ),
                  child: QuickMenuButton(
                    color: Palette.primary,
                    icon: Icons.upload,
                    size: size / 4,
                    enabled: true,
                    onPressed: building.onUpgrade,
                  ),
                ),
                QuickMenuButton(
                  color: Palette.success,
                  icon: Icons.add,
                  size: size / 4,
                  enabled: colony.hasFreeVillagers,
                  onPressed: building.onAddVillager,
                ),
                QuickMenuButton(
                  color: Palette.error,
                  icon: Icons.remove,
                  size: size / 4,
                  enabled: building.hasWorkers,
                  onPressed: building.onRemoveVillager,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickMenuButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;
  final bool enabled;
  final VoidCallback onPressed;

  const QuickMenuButton({
    required this.color,
    required this.icon,
    required this.size,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: enabled ? color : Palette.lightGrey,
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
          onTap: enabled ? onPressed : null,
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
