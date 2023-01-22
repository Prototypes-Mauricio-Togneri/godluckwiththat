import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tensionnode/platform/platform_initializer.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:url_strategy/url_strategy.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();
    setPathUrlStrategy();
    locator.registerSingleton<Navigation>(Navigation());
    Palette.init();
    PlatformInitializer.init();
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
  }
}
