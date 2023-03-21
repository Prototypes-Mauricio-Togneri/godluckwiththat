import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menu_button.dart';
import 'package:tensionplanet/widgets/menus/building_menu.dart';
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
        width: 350,
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
            const VBox(20),
            ImageAsset(
              path: nodeType.sprite,
              size: 80,
            ),
            const VBox(20),
            InfoRow(
              message: 'Cost:',
              resourceMap: nodeType.cost,
            ),
            if (nodeType.output.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Label(
                  text: 'Produces:',
                  color: Palette.white,
                ),
              ),
            if (nodeType.output.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RecipeSection(nodeType),
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

class InfoRow extends StatelessWidget {
  final String message;
  final ResourceMap resourceMap;

  const InfoRow({
    required this.message,
    required this.resourceMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Label(
            text: message,
            color: Palette.white,
            align: TextAlign.center,
          ),
          for (final Resource resource in resourceMap.resources())
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ResourceIcon(
                resourceType: resource.resourceType,
                amount: resource.amount.toString(),
                size: 40,
              ),
            ),
        ],
      ),
    );
  }
}
