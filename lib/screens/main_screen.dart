import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/palette.dart';

class MainScreen extends StatelessWidget {
  final MainState state;

  const MainScreen(this.state);

  factory MainScreen.instance() => MainScreen(MainState());

  @override
  Widget build(BuildContext context) {
    return StateProvider<MainState>(
      state: state,
      builder: (context, state) => Content(state),
    );
  }
}

class Content extends StatelessWidget {
  final MainState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Palette.black,
      body: Center(
        child: Text(
          'Tension Node',
          style: TextStyle(
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}

class MainState extends BaseState {}
