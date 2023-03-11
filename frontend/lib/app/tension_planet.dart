import 'package:flutter/material.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/screens/splash_screen.dart';
import 'package:tensionplanet/screens/web_initial_screen.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/platform.dart';

class TensionPlanet extends StatelessWidget {
  const TensionPlanet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tension Planet',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.getRoutes.key,
      theme: ThemeData(
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.black,
        fontFamily: Constants.FONT_NAME,
      ),
      home: _home(),
    );
  }

  Widget _home() =>
      Platform.isWeb ? WebInitialScreen.instance() : SplashScreen.instance();
}
