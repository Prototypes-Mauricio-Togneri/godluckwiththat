import 'package:flutter/material.dart';
import 'package:tensionnode/screens/main_screen.dart';
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
        primarySwatch: Palette.primary,
        backgroundColor: Palette.white,
        scaffoldBackgroundColor: Palette.white,
      ),
      home: MainScreen.instance(),
    );
  }
}
