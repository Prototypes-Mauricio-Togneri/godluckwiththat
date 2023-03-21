import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
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
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                'images/${resourceType.sprite}',
                fit: BoxFit.cover,
              ),
            ),
            const VBox(10),
            const Label(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              color: Palette.white,
              align: TextAlign.center,
              size: 12,
              height: 1.5,
            ),
            const VBox(20),
            const Label(
              text: 'Produced in:',
              color: Palette.white,
            ),
            const VBox(10),
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'images/${NodeType.circuit_assembly.sprite}',
              ),
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
            const VBox(10),
            //for (final Resource resource in resourceMap.resources())
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: ResourceIcon(
                resourceType: ResourceType.circuit,
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
