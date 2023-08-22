import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/dialog/window_dialog.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/amount_selector.dart';
import 'package:godluckwiththat/widgets/label.dart';
import 'package:godluckwiththat/widgets/primary_button.dart';

class CreateExplorationDialog extends StatelessWidget {
  final GameState gameState;
  final CreateExplorationState dialogState;

  const CreateExplorationDialog._(this.gameState, this.dialogState);

  static DialogController show({
    required PatchType patchType,
    required GameState state,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => CreateExplorationDialog._(
        state,
        CreateExplorationState(patchType, state),
      ),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return WindowDialog(
      title: 'New Exploration',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StateProvider(
          state: dialogState,
          builder: (context, state) => Column(
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
                    text: state.villagers.toString(),
                    color: Palette.white,
                    size: 30,
                    onRemove: state.canRemoveVillagers
                        ? state.decreaseVillagers
                        : null,
                    onAdd:
                        state.canAddVillagers ? state.increaseVillagers : null,
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
                    text: state.days.toString(),
                    color: Palette.white,
                    size: 30,
                    onRemove: state.canRemoveDays ? state.decreaseDays : null,
                    onAdd: state.increaseDays,
                  ),
                ],
              ),
              const VBox(30),
              PrimaryButton(
                text: 'Send',
                expand: true,
                color: Palette.success,
                onPressed: state.onSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateExplorationState extends BaseState {
  final PatchType patchType;
  final GameState state;
  int villagers = 1;
  int days = 1;

  CreateExplorationState(this.patchType, this.state);

  bool get canAddVillagers => villagers < state.colony.freeVillagers;

  bool get canRemoveVillagers => villagers > 1;

  void increaseVillagers() {
    villagers++;
    notify();
  }

  void decreaseVillagers() {
    villagers--;
    notify();
  }

  bool get canRemoveDays => days > 1;

  void increaseDays() {
    days++;
    notify();
  }

  void decreaseDays() {
    days--;
    notify();
  }

  void onSend() {
    state.onAddExplorationTask(ExplorationTask.create(
      patchType: patchType,
      villagers: villagers,
      days: days,
    ));
    Navigation.pop();
  }
}
