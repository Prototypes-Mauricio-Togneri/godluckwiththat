import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/menu_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.darkGrey,
      width: 300,
      height: double.infinity,
      child: Column(
        children: [
          MenuButton(
            text: 'Town Center',
            icon: Icons.location_city,
            selected: state.isSelected(MenuType.headquarters),
            onPressed: () => state.onMenuSelected(MenuType.headquarters),
          ),
          MenuButton(
            text: 'Water',
            icon: Icons.water_drop,
            selected: state.isSelected(MenuType.water),
            onPressed: () => state.onMenuSelected(MenuType.water),
          ),
          MenuButton(
            text: 'Food',
            icon: Icons.restaurant,
            selected: state.isSelected(MenuType.food),
            onPressed: () => state.onMenuSelected(MenuType.food),
          ),
          MenuButton(
            text: 'Wood',
            icon: Icons.forest,
            selected: state.isSelected(MenuType.wood),
            onPressed: () => state.onMenuSelected(MenuType.wood),
          ),
          MenuButton(
            text: 'Stone',
            icon: Icons.landscape,
            selected: state.isSelected(MenuType.stone),
            onPressed: () => state.onMenuSelected(MenuType.stone),
          ),
          MenuButton(
            text: 'Faith',
            icon: Icons.church,
            selected: state.isSelected(MenuType.faith),
            onPressed: () => state.onMenuSelected(MenuType.faith),
          ),
          /*MenuButton(
            text: 'Warehouse',
            icon: Icons.warehouse,
            selected: state.isSelected(MenuType.warehouse),
            onPressed: () => state.onMenuSelected(MenuType.warehouse),
          ),*/
          /*MenuButton(
            text: 'Market',
            icon: Icons.balance,
            selected: state.isSelected(MenuType.market),
            onPressed: () => state.onMenuSelected(MenuType.market),
          ),*/
          /*MenuButton(
            text: 'Research',
            icon: Icons.science,
            selected: state.isSelected(MenuType.research),
            onPressed: () => state.onMenuSelected(MenuType.research),
          ),*/
          const Spacer(),
          BottomMenu(state),
        ],
      ),
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
                  text: text,
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

class BottomMenu extends StatelessWidget {
  final GameState state;

  const BottomMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimeBlock(state),
        FaithBlock(state),
      ],
    );
  }
}

class TimeBlock extends StatelessWidget {
  final GameState state;

  const TimeBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Palette.transparent,
        border: Border.all(
          width: 3,
          color: Palette.lightGrey,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VBox(10),
          Label(
            text: 'Day: ${state.day}',
            color: Palette.white,
            size: 35,
          ),
          const VBox(10),
          const Label(
            text: 'Summer',
            color: Palette.white,
            size: 35,
          ),
          const VBox(10),
        ],
      ),
    );
  }
}

class FaithBlock extends StatelessWidget {
  final GameState state;

  const FaithBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Palette.transparent,
        border: Border.all(
          width: 3,
          color: Palette.lightGrey,
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VBox(10),
          Label(
            text: 'Faith: 50/100',
            color: Palette.white,
            size: 35,
          ),
          VBox(10),
          Label(
            text: 'Days left: 30',
            color: Palette.white,
            size: 35,
          ),
          VBox(10),
        ],
      ),
    );
  }
}
