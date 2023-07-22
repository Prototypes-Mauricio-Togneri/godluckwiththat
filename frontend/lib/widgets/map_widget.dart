import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class MapWidget extends StatelessWidget {
  final GameState state;

  const MapWidget(this.state);

  @override
  Widget build(BuildContext context) {
    const int mapSize = 7;
    final double size = MediaQuery.of(context).size.height / (mapSize + 1);

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < mapSize; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < mapSize; j++)
                    MapTile(
                      size: size,
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class MapTile extends StatefulWidget {
  final double size;

  const MapTile({
    required this.size,
  });

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  bool mouseOver = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        mouseOver = true;
      }),
      onExit: (event) => setState(() {
        mouseOver = false;
      }),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Palette.black,
          border: Border.all(
            color: mouseOver ? Palette.white : Palette.black,
            width: 1,
          ),
        ),
        child: const Center(
          child: Label(
            text: 'tile',
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
