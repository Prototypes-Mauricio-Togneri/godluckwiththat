import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';

class VillageBackground extends SpriteComponent {
  final String image;

  VillageBackground({
    required this.image,
    required super.size,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);

    return super.onLoad();
  }
}
