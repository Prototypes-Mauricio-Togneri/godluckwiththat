import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/image_asset.dart';
import 'package:gatewayguardians/widgets/label.dart';

class QueueIndicator extends StatelessWidget {
  final String sprite;
  final String value;
  final VoidCallback onTap;

  const QueueIndicator({
    required this.sprite,
    required this.value,
    required this.onTap,
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
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    right: 8,
                  ),
                  child: ImageAsset(
                    path: sprite,
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
        ),
      ),
    );
  }
}
