import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tensionnode/platform/platform_initializer.dart';
import 'package:tensionnode/services/navigation.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA2A6WG6fxumwwrKxOKCYzKZ-bmTkfHuGc',
        projectId: 'tensionnode',
        messagingSenderId: '376547971749',
        appId: '1:376547971749:web:d0e30debf292547050f34c',
      ),
    );

    locator.registerSingleton<Navigation>(Navigation());
    PlatformInitializer.init();
  }
}
