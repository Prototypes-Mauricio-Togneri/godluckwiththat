import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/states/game_state.dart';
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
        children: [
          LeftSection(state.colony),
          /*Label(
            text: 'Day: ${state.colony.day}',
            color: Palette.black,
            size: 14,
          ),
          const Spacer(),
          Label(
            text:
                'Idle villagers: ${state.colony.freeVillagers}/${state.colony.inventory.get(ResourceType.villager)}',
            color: (state.colony.freeVillagers > 0)
                ? Palette.error
                : Palette.black,
            size: 14,
          ),*/
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

class LabeledText extends StatelessWidget {
  final String label;
  final String text;

  const LabeledText({
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: label,
          color: Palette.black,
          weight: FontWeight.bold,
          size: 14,
        ),
        const HBox(5),
        Label(
          text: text,
          color: Palette.black,
          size: 14,
        ),
      ],
    );
  }
}
