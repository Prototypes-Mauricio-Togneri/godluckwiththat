import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/dialog/window_dialog.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/amount_selector.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';

class CreateExplorationDialog extends StatelessWidget {
  final GameState state;

  const CreateExplorationDialog._(this.state);

  static DialogController show(GameState state) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => CreateExplorationDialog._(state),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WindowDialog(
      title: 'New Exploration',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Label(
                  text: 'Villagers',
                  color: Palette.white,
                  size: 30,
                ),
                const Spacer(),
                AmountSelector(
                  text: '1',
                  color: Palette.white,
                  size: 30,
                  onRemove: () {},
                  onAdd: () {},
                ),
              ],
            ),
            const VBox(30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Label(
                  text: 'Days:',
                  color: Palette.white,
                  size: 30,
                ),
                const Spacer(),
                AmountSelector(
                  text: '1',
                  color: Palette.white,
                  size: 30,
                  onRemove: () {},
                  onAdd: () {},
                ),
              ],
            ),
            const VBox(30),
            PrimaryButton(
              text: 'Send',
              expand: true,
              color: Palette.success,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
