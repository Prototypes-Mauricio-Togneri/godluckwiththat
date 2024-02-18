import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class ResourcesHeader extends StatelessWidget {
  final GameState state;

  const ResourcesHeader(this.state);

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
              label: 'Day:',
              text: colony.day.toString(),
            ),
            const HBox(15),
            LabeledText(
              label: 'Year:',
              text: colony.year.toString(),
            ),
          ],
        ),
        const VBox(10),
        const LabeledText(
          label: 'Season:',
          text: 'Summer',
        ),
        const VBox(10),
        const LabeledText(
          label: 'Next challenge:',
          text: '30 days',
        ),
        const VBox(10),
        const LabeledText(
          label: 'Next attack:',
          text: '14 days',
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
          label: 'Idle villagers:',
          text: colony.freeVillagers.toString(),
          labelColor:
              (colony.freeVillagers > 0) ? Palette.error : Palette.black,
          textColor: (colony.freeVillagers > 0) ? Palette.error : Palette.black,
        ),
        const VBox(10),
        LabeledText(
          label: 'Population:',
          text: '${colony.totalPopulation}/${colony.populationLimit}',
        ),
        const VBox(10),
        LabeledText(
          label: 'Water:',
          text: '${colony.inventory.get(ResourceType.water).toInt()}',
        ),
        const VBox(10),
        LabeledText(
          label: 'Food:',
          text: '${colony.inventory.get(ResourceType.food).toInt()}',
        ),
        const VBox(10),
        LabeledText(
          label: 'Wood:',
          text: '${colony.inventory.get(ResourceType.wood).toInt()}',
        ),
        const VBox(10),
        LabeledText(
          label: 'Stone:',
          text: '${colony.inventory.get(ResourceType.stone).toInt()}',
        ),
      ],
    );
  }
}

class LabeledText extends StatelessWidget {
  final String label;
  final String text;
  final Color labelColor;
  final Color textColor;

  const LabeledText({
    required this.label,
    required this.text,
    this.labelColor = Palette.black,
    this.textColor = Palette.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: label,
          color: labelColor,
          weight: FontWeight.bold,
          size: 14,
        ),
        const HBox(5),
        Label(
          text: text,
          color: textColor,
          size: 14,
        ),
      ],
    );
  }
}
