import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/widgets/label.dart';
import 'package:tensionplanet/widgets/menus/item_row.dart';

class ResourcesSection extends StatelessWidget {
  final String title;
  final List<Resource> resources;

  const ResourcesSection({
    required this.title,
    required this.resources,
  });

  @override
  Widget build(BuildContext context) {
    if (resources.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VBox(20),
          Label(
            text: title.toUpperCase(),
            align: TextAlign.center,
          ),
          const VBox(10),
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
