import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/event.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';
import 'package:godluckwiththat/widgets/misc/hovered.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeftMenuTitle(state),
          const HorizontalDivider(
            color: Palette.divider1,
            height: 1,
          ),
          for (final Event event in state.colony.events)
            LeftMenuRow(
              event: event,
              onSelected: () => state.onEventSelected(event),
              onClosed: () => state.onEventClosed(event),
            ),
        ],
      ),
    );
  }
}

class LeftMenuTitle extends StatelessWidget {
  final GameState state;

  const LeftMenuTitle(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff7a5e00).withAlpha(150),
            Palette.backgroundTransparent1,
          ],
        ),
      ),
      child: Row(
        children: [
          const HBox(10),
          Expanded(
            child: Label(
              text: 'Events'.toUpperCase(),
              weight: FontWeight.bold,
            ),
          ),
          const HBox(10),
          Material(
            color: Palette.transparent,
            child: InkWell(
              hoverColor: Palette.backgroundClose.withAlpha(150),
              onTap: state.onCleanAllEvents,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.close,
                  size: 15,
                  color: Palette.iconLevel1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftMenuRow extends StatelessWidget {
  final Event event;
  final VoidCallback onSelected;
  final VoidCallback onClosed;

  const LeftMenuRow({
    required this.event,
    required this.onSelected,
    required this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Hovered(
      builder: (context, hovered) => Material(
        color: Palette.backgroundTransparent2,
        child: InkWell(
          hoverColor: Palette.backgroundTransparent1.withAlpha(50),
          onTap: onSelected,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HBox(10),
              Icon(
                event.icon,
                size: 12,
                color: Palette.iconLevel1,
              ),
              const HBox(10),
              Expanded(
                child: Label(text: event.summary),
              ),
              SizedBox(
                width: 35,
                height: 35,
                child: hovered
                    ? Material(
                        color: Palette.transparent,
                        child: InkWell(
                          hoverColor: Palette.backgroundClose.withAlpha(150),
                          onTap: onClosed,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: Palette.iconLevel1,
                            ),
                          ),
                        ),
                      )
                    : const Empty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
