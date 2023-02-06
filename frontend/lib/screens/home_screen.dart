import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/states/home_state.dart';

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
            child: Text(
              'HOME',
              style: TextStyle(
                color: Palette.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
