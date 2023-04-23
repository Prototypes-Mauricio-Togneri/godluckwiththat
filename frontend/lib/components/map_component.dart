import 'dart:async';
import 'package:flame/components.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';

class MapComponent extends SpriteComponent {
  final String image;

  MapComponent({
    required this.image,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }
}
