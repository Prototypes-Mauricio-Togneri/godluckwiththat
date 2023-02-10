import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/home_state.dart';
import 'package:tensionnode/widgets/menu_button.dart';

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
            child: CircularProgressIndicator(),
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
            MenuButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: Palette.primary,
              onPressed: state.onContinue,
              topPadding: 0,
            ),
            MenuButton(
              text: 'Settings',
              icon: Icons.settings,
              color: Palette.primary,
              onPressed: state.onSettings,
            ),
            MenuButton(
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
