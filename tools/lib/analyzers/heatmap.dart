import 'dart:io';
import 'package:image/image.dart';

class Heatmap {
  final String path;
  final int width;
  final int height;
  late final Image image;

  Heatmap({
    required this.path,
    required this.width,
    required this.height,
  }) {
    image = Image(width, height);
  }

  void pointAbsolute(int positionX, int positionY, int size, int color) => fillCircle(image, positionX, height - positionY, size, color);

  void pointPercentage(int positionX, int positionY, int size, int color) {
    final int x = ((positionX / 100) * width).toInt();
    final int y = ((positionY / 100) * height).toInt();
    pointAbsolute(x, y, size, color);
  }

  void write() {
    final File file = File(path);
    file.writeAsBytesSync(encodePng(image));
  }
}
