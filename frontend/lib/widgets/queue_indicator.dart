import 'package:flutter/material.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';

class QueueIndicator extends StatelessWidget {
  final ResourceType resourceType;
  final String value;

  const QueueIndicator({
    required this.resourceType,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Palette.grey,
        border: Border.all(
          width: 2,
          color: Palette.lightGrey,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 8,
              ),
              child: ImageAsset(
                path: resourceType.sprite,
                size: 30,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 3,
                right: 3,
              ),
              child: Label(
                text: value,
                color: Palette.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
