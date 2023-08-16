import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class WorkersSelector extends StatelessWidget {
  final Building building;

  const WorkersSelector(this.building);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WorkerSelectorButton(
          icon: Icons.remove,
          color: Palette.error,
          onTap: building.canRemoveVillagers ? building.removeVillagers : null,
        ),
        const HBox(10),
        Label(
          text: '${building.villagers}/${building.level}',
          color: building.villagersAmountColor,
          size: 35,
        ),
        const HBox(10),
        WorkerSelectorButton(
          icon: Icons.add,
          color: Palette.success,
          onTap: building.canAddVillagers ? building.addVillager : null,
        ),
      ],
    );
  }
}

class WorkerSelectorButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const WorkerSelectorButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      color: (onTap != null) ? color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: Palette.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
