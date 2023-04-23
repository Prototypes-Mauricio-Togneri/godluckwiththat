import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/states/home_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  final HomeState state;

  const HomeScreen(this.state);

  factory HomeScreen.instance() => HomeScreen(HomeState());

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

class Content extends StatelessWidget {
  final HomeState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Palette.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.primary,
              onPressed: state.onContinue,
            ),
            PrimaryButton(
              text: 'Settings',
              icon: Icons.settings,
              color: Palette.primary,
              onPressed: state.onSettings,
            ),
            PrimaryButton(
              text: 'Info',
              icon: Icons.info,
              color: Palette.primary,
              onPressed: state.onInfo,
            ),
          ],
        ),
      ),
    );
  }
}
