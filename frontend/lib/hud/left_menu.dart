import 'package:flutter/material.dart';
import 'package:gatewayguardians/states/menu_state.dart';
import 'package:gatewayguardians/types/menu_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class LeftMenu extends StatelessWidget {
  final MenuState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.darkGrey,
      width: 300,
      height: double.infinity,
      child: MenuButtons(state),
    );
  }
}

class MenuButtons extends StatelessWidget {
  final MenuState state;

  const MenuButtons(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuButton(
          text: 'TOWN CENTER',
          icon: Icons.location_city,
          selected: state.isSelected(MenuType.headquarters),
          onPressed: () => state.onMenuSelected(MenuType.headquarters),
        ),
        MenuButton(
          text: 'WATER',
          icon: Icons.water_drop,
          selected: state.isSelected(MenuType.water),
          onPressed: () => state.onMenuSelected(MenuType.water),
        ),
        MenuButton(
          text: 'FOOD',
          icon: Icons.restaurant,
          selected: state.isSelected(MenuType.food),
          onPressed: () => state.onMenuSelected(MenuType.food),
        ),
        MenuButton(
          text: 'WOOD',
          icon: Icons.forest,
          selected: state.isSelected(MenuType.wood),
          onPressed: () => state.onMenuSelected(MenuType.wood),
        ),
        MenuButton(
          text: 'STONE',
          icon: Icons.landscape,
          selected: state.isSelected(MenuType.stone),
          onPressed: () => state.onMenuSelected(MenuType.stone),
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const MenuButton({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: selected ? Palette.lightGrey : Palette.transparent,
        border: Border.all(
          width: 3,
          color: selected ? Palette.white : Palette.transparent,
        ),
      ),
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 1,
              left: 15,
              right: 15,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    icon,
                    color: Palette.white,
                    size: 24,
                  ),
                ),
                Label(
                  text: text.toUpperCase(),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
