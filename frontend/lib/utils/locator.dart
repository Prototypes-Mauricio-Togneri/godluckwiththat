import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:godluckwiththat/platform/platform_initializer.dart';
import 'package:godluckwiththat/utils/navigation.dart';

final GetIt locator = GetIt.instance;

class Locator {
  static Future load() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAqdJALmU6x0eGQN6zx545hU3zPFoLWk1U',
        authDomain: 'godluckwiththat.firebaseapp.com',
        projectId: 'godluckwiththat',
        storageBucket: 'godluckwiththat.appspot.com',
        messagingSenderId: '699860745717',
        appId: '1:699860745717:web:959c0dd7e19fb9d10874bc',
        measurementId: 'G-YW85L356Y1',
      ),
    );

    locator.registerSingleton<Navigation>(Navigation());
    PlatformInitializer.init();
  }
}
