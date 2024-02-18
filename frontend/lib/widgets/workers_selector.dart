import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/amount_selector.dart';

class WorkersSelector extends StatelessWidget {
  final Building building;
  final double size;

  const WorkersSelector({
    required this.building,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AmountSelector(
      text: '${building.villagers}/${building.maxCapacity}',
      color: (building.villagers == 0) ? Palette.error : Palette.black,
      size: size,
      onRemove: building.canRemoveVillagers ? building.removeVillagers : null,
      onAdd: building.canAddVillagers ? building.addVillager : null,
    );
  }
}
