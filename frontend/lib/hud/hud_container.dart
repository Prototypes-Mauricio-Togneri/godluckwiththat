import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/menu_button_hud.dart';
import 'package:tensionplanet/hud/resource_hud.dart';
import 'package:tensionplanet/hud/village_switcher_hud.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class HudContainer extends StatelessWidget {
  final GameState state;

  const HudContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          VillageSwitcherHud(state),
          ResourceHud(state),
          MenuButtonHud(state),
          if (state.selectedBuilding != null)
            Positioned(
              top: (constraints.maxHeight * state.selectedBuilding!.offset.dy) -
                  (constraints.maxHeight / 10),
              left: (constraints.maxWidth * state.selectedBuilding!.offset.dx) -
                  (constraints.maxHeight / 10),
              child: BuildingQuickMenu(
                building: state.selectedBuilding!,
                size: constraints.maxHeight / 5,
              ),
            ),
        ],
      ),
    );
  }
}

class BuildingQuickMenu extends StatelessWidget {
  final Building building;
  final double size;

  const BuildingQuickMenu({
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
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickMenuButton(
                  color: Palette.primary,
                  icon: Icons.upload,
                  size: size / 4,
                  onPressed: building.onUpgrade,
                ),
                QuickMenuButton(
                  color: Palette.success,
                  icon: Icons.add,
                  size: size / 4,
                  onPressed: building.onAddVillager,
                ),
                QuickMenuButton(
                  color: Palette.error,
                  icon: Icons.remove,
                  size: size / 4,
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
  final VoidCallback onPressed;

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
        color: color,
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
