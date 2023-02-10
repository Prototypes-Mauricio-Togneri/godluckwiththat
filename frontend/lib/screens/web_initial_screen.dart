import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/services/navigation.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/label.dart';

class WebInitialScreen extends StatelessWidget {
  const WebInitialScreen._();

  factory WebInitialScreen.instance() => const WebInitialScreen._();

  @override
  Widget build(BuildContext context) {
    return CustomStatusBar(
      style: SystemUiOverlayStyle.light,
      statusBarColor: Palette.grey,
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: Navigation.splashScreen,
            child: Container(
              color: Palette.black,
              child: const Center(
                child: Label(text: 'TAP TO START'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
