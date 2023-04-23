import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/states/splash_state.dart';
import 'package:gatewayguardians/utils/palette.dart';

class SplashScreen extends StatelessWidget {
  final SplashState state;

  const SplashScreen(this.state);

  factory SplashScreen.instance() => SplashScreen(SplashState());

  @override
  Widget build(BuildContext context) {
    return const CustomStatusBar(
      style: SystemUiOverlayStyle.light,
      statusBarColor: Palette.grey,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Palette.white,
            ),
          ),
        ),
      ),
    );
  }
}
