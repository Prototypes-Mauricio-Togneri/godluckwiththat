import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';

class ZoneComponent extends SpriteComponent with Tappable, Hoverable {
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
  bool onHoverEnter(PointerHoverInfo info) {
    tint(const Color(0x33ffffff));

    return true;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    tint(const Color(0x00000000));

    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('aaa');

    return true;
  }
}
