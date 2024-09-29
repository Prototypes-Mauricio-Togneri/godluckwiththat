import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeftMenuTitle(state),
          HorizontalDivider(
            color: Palette.divider1,
            height: 1,
          ),
          LeftMenuRow(
            text: 'Worker created',
            icon: Icons.person,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Winter coming',
            icon: Icons.ac_unit,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Earthquake happened',
            icon: Icons.warning,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Challenge completed',
            icon: Icons.check,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Solider created',
            icon: Icons.security,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Building created',
            icon: Icons.home,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Research completed',
            icon: Icons.science,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Population limit reached',
            icon: Icons.group,
            onPressed: state.onEvent,
          ),
          LeftMenuRow(
            text: 'Territory slot reached',
            icon: Icons.map,
            onPressed: state.onEvent,
          ),
        ],
      ),
    );
  }
}

class LeftMenuTitle extends StatelessWidget {
  final GameState state;

  const LeftMenuTitle(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.backgroundTransparent1,
      child: Row(
        children: [
          const HBox(10),
          const Expanded(
            child: Label(
              text: 'Events',
              weight: FontWeight.bold,
            ),
          ),
          const HBox(10),
          Material(
            color: Palette.transparent,
            child: InkWell(
              onTap: state.onCleanAllEvents,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.cleaning_services_outlined,
                  size: 15,
                  color: Palette.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftMenuRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const LeftMenuRow({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Palette.backgroundTransparent2,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12,
                  color: Palette.white,
                ),
                const HBox(10),
                Expanded(child: Label(text: text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
