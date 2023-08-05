import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/utils/assets.dart';

class Images {
  static final Map<String, Image> _map = {};

  static Future load() async {
    await _load(Assets.IMAGES_MAPS_MAP1);

    await _load(Assets.IMAGES_TILES_FOG);
    await _load(Assets.IMAGES_TILES_GRASS);
    await _load(Assets.IMAGES_TILES_WATER);

    await _load(Assets.IMAGES_PATCHES_CROP_FIELD);
    await _load(Assets.IMAGES_PATCHES_FOREST);
    await _load(Assets.IMAGES_PATCHES_STONE_DEPOSIT);

    await _load(Assets.IMAGES_BUILDINGS_MISC_HEADQUARTERS);
    await _load(Assets.IMAGES_BUILDINGS_MISC_HOUSE);
    await _load(Assets.IMAGES_BUILDINGS_MISC_WAREHOUSE);

    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_FARM);
    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_WOODCUTTER);
    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY);
    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_COPPER_MINE);
    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_IRON_MINE);
    await _load(Assets.IMAGES_BUILDINGS_PRODUCERS_GOLD_MINE);
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
