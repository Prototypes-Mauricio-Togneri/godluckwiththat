import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';

class ZoneComponent extends SpriteComponent with Tappable {
  final String image;

  ZoneComponent({
    required this.image,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('aaa');

    return true;
  }
}
