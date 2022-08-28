import 'package:flutter/material.dart';
import 'package:tensionnode/json/json_map.dart';

class GameMap {
  final TransformationController transformationController = TransformationController();
  final int numberOfBlocksHorizontal;
  final int numberOfBlocksVertical;
  final int blockSize;
  Size mapLayoutSize = Size.zero;

  GameMap({
    required this.numberOfBlocksHorizontal,
    required this.numberOfBlocksVertical,
    required this.blockSize,
  });

  double get maxZoom => blockSize * 2;

  Size get dimensions => Size(
        numberOfBlocksHorizontal.toDouble(),
        numberOfBlocksVertical.toDouble(),
      );

  Size get size => Size(
        (blockSize * dimensions.width).toDouble(),
        (blockSize * dimensions.height).toDouble(),
      );

  double get currentZoom => transformationController.value.getMaxScaleOnAxis();

  Rect get viewport {
    final Matrix4 matrix = Matrix4.inverted(transformationController.value);
    final double zoom = currentZoom;

    return Rect.fromLTWH(
      matrix.row0[3],
      matrix.row1[3],
      mapLayoutSize.width / zoom,
      mapLayoutSize.height / zoom,
    );
  }

  void setCenter() {
    const double zoom = 5;
    final Size screenSize = WidgetsBinding.instance.window.physicalSize;
    final double xTranslate = (dimensions.width * blockSize * zoom / 2) - (screenSize.width / 2) + 170;
    final double yTranslate = (dimensions.height * blockSize * zoom / 2) - (screenSize.height / 2) + 40;

    transformationController.value.setEntry(0, 0, zoom);
    transformationController.value.setEntry(1, 1, zoom);
    transformationController.value.setEntry(2, 2, zoom);
    transformationController.value.setEntry(0, 3, -xTranslate);
    transformationController.value.setEntry(1, 3, -yTranslate);
  }

  void moveUp() {
    final double delta = maxZoom - currentZoom + 1;
    transformationController.value.translate(0, delta);
  }

  void moveDown() {
    final double delta = maxZoom - currentZoom + 1;
    transformationController.value.translate(0, -delta);
  }

  void moveLeft() {
    final double delta = maxZoom - currentZoom + 1;
    transformationController.value.translate(delta);
  }

  void moveRight() {
    final double delta = maxZoom - currentZoom + 1;
    transformationController.value.translate(-delta);
  }

  Offset gameToReal(Offset position) => Offset(
        (position.dx + (dimensions.width / 2)) * blockSize,
        (position.dy + (dimensions.height / 2)) * blockSize,
      );

  Offset realToGame(Offset position) => Offset(
        (position.dx / blockSize).round() - (dimensions.width / 2),
        (position.dy / blockSize).round() - (dimensions.height / 2),
      );

  JsonMap get json => JsonMap(
        numberOfBlocksHorizontal: numberOfBlocksHorizontal,
        numberOfBlocksVertical: numberOfBlocksVertical,
        blockSize: blockSize,
      );
}
