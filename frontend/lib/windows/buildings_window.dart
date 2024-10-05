import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/views/resources_view.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class BuildingsWindow extends StatelessWidget {
  final GameState state;

  const BuildingsWindow(this.state);

  static DialogController show(GameState state) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => BuildingsWindow(state),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: 'Buildings',
      child: Container(
        color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ResourcesView(state),
          ],
        ),
      ),
    );
  }
}
