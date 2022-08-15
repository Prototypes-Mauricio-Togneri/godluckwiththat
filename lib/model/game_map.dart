import 'package:flutter/rendering.dart';

class GameMap {
  final int numberOfBlocksHorizontal;
  final int numberOfBlocksVertical;
  final int blockSize;

  const GameMap({
    required this.numberOfBlocksHorizontal,
    required this.numberOfBlocksVertical,
    required this.blockSize,
  });

  Size get dimensions => Size(
        numberOfBlocksHorizontal.toDouble(),
        numberOfBlocksVertical.toDouble(),
      );

  Size get size => Size(
        (blockSize * dimensions.width).toDouble(),
        (blockSize * dimensions.height).toDouble(),
      );

  Offset center({
    required double zoom,
    required Size screenSize,
  }) {
    final double xTranslate = ((dimensions.width / 2) * blockSize * zoom) - (screenSize.width / 2);
    final double yTranslate = ((dimensions.height / 2) * blockSize * zoom) - (screenSize.height / 2);

    return Offset(xTranslate, yTranslate);
  }
}
