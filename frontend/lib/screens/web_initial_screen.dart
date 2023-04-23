import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/utils/localizations.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

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
              child: Center(
                child: Label(text: Localized.get.splashWeb),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
