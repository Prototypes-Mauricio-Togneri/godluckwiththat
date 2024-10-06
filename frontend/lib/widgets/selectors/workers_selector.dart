import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/selectors/amount_selector.dart';

class WorkersSelector extends StatelessWidget {
  final Producer building;
  final double size;

  const WorkersSelector({
    required this.building,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AmountSelector(
      text:
          '${Formatter.resource(building.workers)}/${Formatter.resource(building.maxWorkersCapacity)}',
      color: (building.workers == 0) ? Palette.textError : Palette.textLevel2,
      size: size,
      image: Assets.IMAGES_UNITS_WORKER,
      onRemove: building.canRemoveWorkers ? building.removeWorkers : null,
      onAdd: building.canAddWorkers ? building.addWorkers : null,
    );
  }
}
