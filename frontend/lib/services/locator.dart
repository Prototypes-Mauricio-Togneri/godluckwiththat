import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get_it/get_it.dart';
import 'package:tensionnode/platform/platform_initializer.dart';
import 'package:tensionnode/services/empty_url_strategy.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();
    setUrlStrategy(EmptyUrlStrategy());
    locator.registerSingleton<Navigation>(Navigation());
    Palette.init();
    PlatformInitializer.init();
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();
  }
}
