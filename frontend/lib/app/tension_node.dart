import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/screens/game_screen2.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';

class TensionNode extends StatelessWidget {
  const TensionNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tension Node',
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.get.routes.key,
      theme: ThemeData(
        primaryColor: Palette.primary,
        primarySwatch: Palette.primary,
        backgroundColor: Palette.white,
        scaffoldBackgroundColor: Palette.black,
        fontFamily: Constants.FONT_NAME,
      ),
      home: GameScreen2.instance(),
    );
  }
}
