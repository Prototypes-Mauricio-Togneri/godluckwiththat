import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/utils/assets.dart';

class Images {
  static late final Image imageTileGrass;
  static late final Image imageTileWater;

  static Future load() async {
    imageTileGrass = await _load(Assets.IMAGES_TILES_GRASS);
    imageTileWater = await _load(Assets.IMAGES_TILES_WATER);
  }

  static Future _load(String path) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List());
    final FrameInfo frame = await codec.getNextFrame();

    return frame.image;
  }
}
