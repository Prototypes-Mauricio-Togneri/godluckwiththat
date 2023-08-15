import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/image_asset.dart';
import 'package:godluckwiththat/widgets/label.dart';

class QueueIndicator extends StatelessWidget {
  final String sprite;
  final double progress;
  final int size;
  final VoidCallback onTap;

  const QueueIndicator({
    required this.sprite,
    required this.progress,
    required this.size,
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
              Container(
                width: 45 * progress,
                height: 3,
                color: Palette.success,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 0,
                    right: 0,
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
                    text: size.toString(),
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
