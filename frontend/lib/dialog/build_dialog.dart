import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/dialog/window_dialog.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';

class BuildDialog extends StatelessWidget {
  final GameState state;

  const BuildDialog._(this.state);

  static DialogController show({
    required GameState state,
  }) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Palette.transparent,
      builder: (context) => BuildDialog._(state),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return const WindowDialog(
      title: 'Build',
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*if (island.basic().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in island.basic())
                      DirectBuild(
                        state: state,
                        island: island,
                        buildingType: buildingType,
                      ),
                  ],
                ),
              ),
            if (island.producers().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in island.producers())
                      DirectBuild(
                        state: state,
                        island: island,
                        buildingType: buildingType,
                      ),
                  ],
                ),
              ),*/
            /*if (island.military().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final BuildingType buildingType in island.military())
                      DirectBuild(
                        state: state,
                        island: island,
                        buildingType: buildingType,
                      ),
                  ],
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}

class DirectBuild extends StatelessWidget {
  final GameState state;
  final BuildingType buildingType;

  const DirectBuild({
    required this.state,
    required this.buildingType,
  });

  @override
  Widget build(BuildContext context) {
    return const Empty();
    /*return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: BuildingBlock(
        state: state,
        island: island,
        buildingType: buildingType,
        onBuild: () {
          Navigation.pop();
          state.build(
            island: island,
            buildingType: buildingType,
          );
        },
      ),
    );*/
  }
}

/*class BuildingBlock extends StatelessWidget {
  final GameState state;
  final Island island;
  final BuildingType buildingType;
  final VoidCallback onBuild;

  const BuildingBlock({
    required this.state,
    required this.island,
    required this.buildingType,
    required this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 155,
      color: Palette.grey,
      child: Column(
        children: [
          Container(
            height: 25,
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 10,
              right: 10,
            ),
            color: Palette.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  text: buildingType.toString(),
                  size: 10,
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 150,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ImageAsset(
                      path: Assets.IMAGES_TILES_GRASS,
                      width: 150,
                      height: 130,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ImageAsset(
                        path: buildingType.sprite,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTooltip(
                  content: Label(
                    text: buildingType.cost(1).join(),
                    color: Palette.white,
                    size: 10,
                  ),
                  child: PrimaryButton(
                    text: 'Build',
                    color: Palette.success,
                    icon: Icons.construction,
                    textSize: 10,
                    tooltipError: buildingType.cost(1).join(),
                    onPressed: state.colony.inventory
                            .hasResources(buildingType.cost(1))
                        ? onBuild
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
