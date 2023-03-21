import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/resource_icon.dart';

class ResourceInfoDialog extends StatelessWidget {
  final ResourceType resourceType;

  const ResourceInfoDialog._({
    required this.resourceType,
  });

  static DialogController show({
    required BuildContext context,
    required ResourceType resourceType,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => ResourceInfoDialog._(
        resourceType: resourceType,
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
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              color: Palette.lightGrey,
              child: Label(
                text: resourceType.toString(),
                color: Palette.white,
                align: TextAlign.center,
              ),
            ),
            const VBox(10),
            ImageAsset(
              path: resourceType.sprite,
              size: 50,
            ),
            const VBox(20),
            const Label(
              text: 'Produced in:',
              color: Palette.white,
            ),
            const VBox(10),
            ImageAsset(
              path: NodeType.circuit_assembly.sprite,
              size: 50,
            ),
            const VBox(5),
            const Label(
              text: 'XXX',
              color: Palette.white,
              size: 12,
            ),
            const VBox(20),
            const Label(
              text: 'Used for:',
              color: Palette.white,
            ),
            for (final ResourceType resourceType
                in ResourceType.usedFor(resourceType))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ResourceIcon(
                  resourceType: resourceType,
                  amount: '',
                  size: 40,
                ),
              ),
            const VBox(20),
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
