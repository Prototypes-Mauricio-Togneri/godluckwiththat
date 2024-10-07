import 'package:dafluta/dafluta.dart';
import 'package:flutter/widgets.dart';
import 'package:godluckwiththat/utils/assets.dart';
import 'package:godluckwiththat/utils/navigation.dart';

class SplashState extends BaseState {
  @override
  Future onLoad() async {
    await loadImages();
    Delayed.post(Navigation.homeScreen);
  }

  Future loadImages() => Future.wait([
        _loadImage(Assets.IMAGES_BACKGROUNDS_BACKGROUND),
        _loadImage(Assets.IMAGES_BUILDINGS_MISC_HEADQUARTERS),
        _loadImage(Assets.IMAGES_BUILDINGS_MISC_HOUSE),
        _loadImage(Assets.IMAGES_BUILDINGS_MISC_STOREHOUSE),
        _loadImage(Assets.IMAGES_BUILDINGS_MISC_ACADEMY),
        _loadImage(Assets.IMAGES_BUILDINGS_MISC_MARKET),
        _loadImage(Assets.IMAGES_BUILDINGS_RELIGIOUS_ALTAR),
        _loadImage(Assets.IMAGES_BUILDINGS_RELIGIOUS_SHRINE),
        _loadImage(Assets.IMAGES_BUILDINGS_RELIGIOUS_TEMPLE),
        _loadImage(Assets.IMAGES_BUILDINGS_RELIGIOUS_MONUMENT),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_FARM),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_WOODCUTTER),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_QUARRY),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_COPPER_MINE),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_IRON_MINE),
        _loadImage(Assets.IMAGES_BUILDINGS_RESOURCES_GOLD_MINE),
        _loadImage(Assets.IMAGES_OTHER_HOUSE),
        _loadImage(Assets.IMAGES_OTHER_IDLE),
        _loadImage(Assets.IMAGES_OTHER_UPGRADE),
        _loadImage(Assets.IMAGES_RESOURCES_FOOD),
        _loadImage(Assets.IMAGES_RESOURCES_WOOD),
        _loadImage(Assets.IMAGES_RESOURCES_STONE),
        _loadImage(Assets.IMAGES_RESOURCES_COPPER),
        _loadImage(Assets.IMAGES_RESOURCES_IRON),
        _loadImage(Assets.IMAGES_RESOURCES_GOLD),
        _loadImage(Assets.IMAGES_RESOURCES_KNOWLEDGE),
        _loadImage(Assets.IMAGES_RESOURCES_FAITH),
        _loadImage(Assets.IMAGES_UNITS_WORKER),
      ]);

  Future _loadImage(String path) => precacheImage(
        AssetImage(path),
        Navigation.context,
      );
}
