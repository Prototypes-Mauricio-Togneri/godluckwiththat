import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/home_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/buttons/primary_button.dart';

class HomeScreen extends StatelessWidget {
  final HomeState state;

  const HomeScreen(this.state);

  factory HomeScreen.instance() => HomeScreen(HomeState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Palette.iconLevel1,
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
      /*decoration: BoxDecoration(
        color: Palette.grey,
        borderRadius: BorderRadius.circular(5),
      ),*/
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.buttonPrimary,
              onPressed: state.onContinue,
            ),
            PrimaryButton(
              text: 'Settings',
              icon: Icons.settings,
              color: Palette.buttonPrimary,
              onPressed: state.onSettings,
            ),
            PrimaryButton(
              text: 'Info',
              icon: Icons.info,
              color: Palette.buttonPrimary,
              onPressed: state.onInfo,
            ),
          ],
        ),
      ),
    );
  }
}
