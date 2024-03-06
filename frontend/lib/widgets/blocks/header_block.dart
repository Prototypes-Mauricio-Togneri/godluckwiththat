import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/labeled_text.dart';

class HeaderBlock extends StatelessWidget {
  final GameState state;

  const HeaderBlock(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSection(state.colony),
          const Spacer(),
          RightSection(state.colony),
        ],
      ),
    );
  }
}

class LeftSection extends StatelessWidget {
  final Colony colony;

  const LeftSection(this.colony);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledText(
              label: 'DAY:',
              text: Formatter.days(colony.day),
            ),
            const HBox(15),
            LabeledText(
              label: 'YEAR:',
              text: Formatter.years(colony.year),
            ),
          ],
        ),
        const VBox(10),
        LabeledText(
          label: 'COLONY SIZE:',
          text: '${colony.territorySlotsUsed}/${colony.territorySlotsTotal}',
        ),
        const VBox(10),
        const LabeledText(
          label: 'SEASON:',
          text: 'SUMMER',
        ),
        const VBox(10),
        const LabeledText(
          label: 'NEXT CHALLENGE:',
          text: '30 DAYS',
        ),
        const VBox(10),
        const LabeledText(
          label: 'NEXT ATTACK:',
          text: '14 DAYS',
        ),
      ],
    );
  }
}

class RightSection extends StatelessWidget {
  final Colony colony;

  const RightSection(this.colony);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LabeledText(
          label: 'IDLE VILLAGERS:',
          text: colony.freeVillagers.toString(),
          labelColor:
              (colony.freeVillagers > 0) ? Palette.error : Palette.black,
          textColor: (colony.freeVillagers > 0) ? Palette.error : Palette.black,
        ),
        const VBox(10),
        LabeledText(
          label: 'POPULATION:',
          text:
              '${Formatter.resource(colony.currentPopulation)}/${Formatter.resource(colony.populationLimit)}',
        ),
        const VBox(10),
        ResourceLabel(
          colony: colony,
          resourceType: ResourceType.food,
        ),
        const VBox(10),
        ResourceLabel(
          colony: colony,
          resourceType: ResourceType.wood,
        ),
        const VBox(10),
        ResourceLabel(
          colony: colony,
          resourceType: ResourceType.stone,
        ),
      ],
    );
  }
}

class ResourceLabel extends StatelessWidget {
  final Colony colony;
  final ResourceType resourceType;

  const ResourceLabel({
    required this.colony,
    required this.resourceType,
  });

  @override
  Widget build(BuildContext context) {
    final num amount = colony.resourceInventory.get(resourceType);
    final num capacity = colony.resourceInventory.capacityOf(resourceType);
    final bool full = amount >= capacity;
    final String production =
        full ? 'FULL' : '${colony.productionOf(resourceType)}/s';

    return LabeledText(
      label: '${resourceType.name.toUpperCase()}:',
      text:
          '${Formatter.resource(amount)}/${Formatter.resource(capacity)} ($production)',
      labelColor: full ? Palette.error : Palette.black,
      textColor: full ? Palette.error : Palette.black,
    );
  }
}
