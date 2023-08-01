import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/utils/assets.dart';

class Images {
  static final Map<String, Image> _map = {};

  static Future load() async {
    await _load(Assets.IMAGES_TILES_GRASS);
    await _load(Assets.IMAGES_TILES_WATER);
    await _load(Assets.IMAGES_PATCHES_CROP_FIELD);
    await _load(Assets.IMAGES_PATCHES_FOREST);
    await _load(Assets.IMAGES_PATCHES_STONE_DEPOSIT);
  }

  static Image image(String path) => _map[path]!;

  static Future _load(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
    final FrameInfo frame = await codec.getNextFrame();
    final Image image = frame.image;
    _map[path] = image;

    return image;
  }
}
