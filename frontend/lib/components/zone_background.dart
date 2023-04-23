import 'dart:async';
import 'package:flame/components.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';

class ZoneBackground extends SpriteComponent {
  final String image;

  ZoneBackground({
    required this.image,
    required super.size,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);

    return super.onLoad();
  }
}
