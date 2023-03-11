import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tensionplanet/platform/platform_initializer.dart';
import 'package:tensionplanet/utils/navigation.dart';

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
          apiKey: 'AIzaSyDWAZs8_dNgfZl6EpLnTI7_P-JRvh4SzBI',
          projectId: 'tensionplanet',
          messagingSenderId: '589993680424',
          appId: '1:589993680424:web:3f2329afb4dc7c37819f1d',
          authDomain: 'tensionplanet.firebaseapp.com',
          storageBucket: 'tensionplanet.appspot.com',
          measurementId: 'G-P4V5HZYCMR'),
    );

    locator.registerSingleton<Navigation>(Navigation());
    PlatformInitializer.init();
  }
}
