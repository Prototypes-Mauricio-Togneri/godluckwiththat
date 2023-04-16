import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/screens/splash_screen.dart';
import 'package:tensionplanet/utils/localizations.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/platform.dart';

class TensionPlanet extends StatelessWidget {
  const TensionPlanet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ENLocalized().applicationName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.black,
        fontFamily: Constants.FONT_NAME,
      ),
      navigatorKey: Navigation.getRoutes.key,
      navigatorObservers: [Navigation.getRoutes.routeObserver],
      localizationsDelegates: const [
        CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localized.locales,
      home: _home(),
    );
  }

  Widget _home() =>
      Platform.isWeb ? SplashScreen.instance() : SplashScreen.instance();
}
