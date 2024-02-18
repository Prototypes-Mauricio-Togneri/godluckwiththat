import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/splash_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/misc/game_container.dart';

class SplashScreen extends StatelessWidget {
  final SplashState state;

  const SplashScreen(this.state);

  factory SplashScreen.instance() => SplashScreen(SplashState());

  @override
  Widget build(BuildContext context) {
    return const GameContainer(
      child: Center(
        child: CircularProgressIndicator(
          color: Palette.white,
        ),
      ),
    );
  }
}
