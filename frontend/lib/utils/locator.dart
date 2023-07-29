import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/platform/platform_initializer.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:get_it/get_it.dart';

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
        apiKey: 'AIzaSyBo50IUbmmoh955SaXT1t3TRFz0NK4ENjQ',
        authDomain: 'gateway-guardians.firebaseapp.com',
        projectId: 'gateway-guardians',
        storageBucket: 'gateway-guardians.appspot.com',
        messagingSenderId: '925734356060',
        appId: '1:925734356060:web:fc665f1a549f75471d9299',
        measurementId: 'G-XLJFFV543L',
      ),
    );

    locator.registerSingleton<Navigation>(Navigation());
    PlatformInitializer.init();
  }
}
