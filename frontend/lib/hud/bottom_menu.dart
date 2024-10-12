import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/misc/custom_tooltip.dart';
import 'package:godluckwiththat/widgets/misc/hovered.dart';

class BottomMenu extends StatelessWidget {
  final GameState state;

  const BottomMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomMenuButton(
            icon: Icons.home,
            tooltip: 'Headquarters',
            onPressed: state.onMenuHeadquarters,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.apartment,
            tooltip: 'Buildings',
            onPressed: state.onMenuBuildings,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.people,
            tooltip: 'Population',
            onPressed: state.onMenuPopulation,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.school,
            tooltip: 'Research',
            onPressed: state.onMenuResearch,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.church,
            tooltip: 'Religion',
            onPressed: state.onMenuReligion,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.shield,
            tooltip: 'Military',
            onPressed: state.onMenuMilitary,
          ),
          const HBox(10),
          BottomMenuButton(
            icon: Icons.balance,
            tooltip: 'Market',
            onPressed: state.onMenuMarket,
          ),
        ],
      ),
    );
  }
}

class BottomMenuButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const BottomMenuButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      content: SimpleTooltip(tooltip),
      child: Material(
        color: Palette.backgroundTransparent1,
        child: InkWell(
          onTap: onPressed,
          child: Hovered(
            builder: (context, hovered) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      hovered ? Palette.borderHighlight : Palette.borderLevel1,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                size: 30,
                color: hovered ? Palette.iconHighlight : Palette.iconLevel1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
