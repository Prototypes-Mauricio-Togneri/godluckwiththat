import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/resource_icon.dart';

class BuildingInfoDialog extends StatelessWidget {
  final NodeType nodeType;

  const BuildingInfoDialog._({
    required this.nodeType,
  });

  static DialogController show({
    required BuildContext context,
    required NodeType nodeType,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => BuildingInfoDialog._(
        nodeType: nodeType,
      ),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
      backgroundColor: Palette.grey,
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              color: Palette.lightGrey,
              child: Label(
                text: nodeType.toString(),
                color: Palette.white,
                align: TextAlign.center,
              ),
            ),
            const VBox(10),
            const Label(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              color: Palette.white,
              size: 12,
              height: 1.5,
            ),
            const VBox(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Label(
                  text: 'Cost:',
                  color: Palette.white,
                  align: TextAlign.center,
                ),
                const HBox(10),
                for (final MapEntry<ResourceType, int> entry
                    in nodeType.cost.entries)
                  ResourceIcon(
                    title: entry.key.toString(),
                    sprite: entry.key.sprite,
                    amount: entry.value.toString(),
                    size: 50,
                  ),
              ],
            ),
            const VBox(10),
            const MenuButton(
              text: 'Close',
              color: Palette.lightGrey,
              onPressed: Navigation.pop,
            ),
          ],
        ),
      ),
    );
  }
}
