import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menus/item_row.dart';

class ResourcesSection extends StatelessWidget {
  final String title;
  final List<Resource> resources;
  final bool horizontal;

  const ResourcesSection({
    required this.title,
    required this.resources,
    required this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (resources.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            color: Palette.lightGrey,
            child: Label(
              text: title,
              align: TextAlign.center,
            ),
          ),
          const VBox(10),
          if (horizontal)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final Resource resource in resources)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ItemRow(
                      title: resource.type.toString(),
                      sprite: resource.type.sprite,
                      amount: '${resource.amount}',
                    ),
                  ),
              ],
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final Resource resource in resources)
                  ItemRow(
                    title: resource.type.toString(),
                    sprite: resource.type.sprite,
                    amount: '${resource.amount}',
                  ),
              ],
            ),
        ],
      );
    } else {
      return const Empty();
    }
  }
}
