import 'package:flutter/material.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/image_asset.dart';
import 'package:tensionplanet/widgets/label.dart';

class ResourceIcon extends StatelessWidget {
  final ResourceType resourceType;
  final String amount;
  final double size;
  final Color border;

  const ResourceIcon({
    required this.resourceType,
    required this.amount,
    required this.size,
    this.border = Palette.lightGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: resourceType.toString().toUpperCase(),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 1,
        left: 6,
        right: 5,
      ),
      textStyle: TextStyle(
        fontSize: size / 4,
        color: Palette.white,
      ),
      decoration: const BoxDecoration(
        color: Palette.black,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundColor: border,
              child: CircleAvatar(
                radius: size / 2.2,
                backgroundColor: Palette.black,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: amount.isEmpty ? size / 5 : 0,
                    bottom: size / 5,
                    left: size / 10,
                    right: size / 10,
                  ),
                  child: ImageAsset(
                    path: resourceType.sprite,
                    size: size,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size / 10),
              child: Label(
                text: amount,
                size: size / 5,
                color: Palette.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
