import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/screens/splash_screen.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';

class TensionNode extends StatelessWidget {
  const TensionNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tension Node',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.getRoutes.key,
      theme: ThemeData(
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        scaffoldBackgroundColor: Palette.black,
        fontFamily: Constants.FONT_NAME,
      ),
      home: SplashScreen.instance(),
    );
  }
}
