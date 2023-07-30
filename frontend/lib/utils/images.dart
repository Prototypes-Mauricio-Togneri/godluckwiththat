import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/utils/assets.dart';

class Images {
  static Image? _image;

  static Future load() async {
    final ByteData data = await rootBundle.load(Assets.IMAGES_TILES_TILE3);
    final codec = await instantiateImageCodec(data.buffer.asUint8List());
    final FrameInfo frame = await codec.getNextFrame();
    _image = frame.image;
  }

  static Image image() => _image!;
}
