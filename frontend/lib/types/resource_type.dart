import 'package:tensionnode/services/assets.dart';

enum ResourceType {
  timber(sprite: Assets.IMAGES_RESOURCES_TIMBER),
  stone(sprite: Assets.IMAGES_RESOURCES_TIMBER),
  wood(sprite: Assets.IMAGES_RESOURCES_TIMBER);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });
}
