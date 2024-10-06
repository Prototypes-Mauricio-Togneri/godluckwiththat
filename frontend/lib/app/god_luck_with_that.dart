import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/screens/splash_screen.dart';
import 'package:godluckwiththat/utils/localizations.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';

class GodLuckWithThat extends StatelessWidget {
  const GodLuckWithThat();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ENLocalized().applicationName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.backgroundLevel1,
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
      home: SplashScreen.instance(),
    );
  }
}
