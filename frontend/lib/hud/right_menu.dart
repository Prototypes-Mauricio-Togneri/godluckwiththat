import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/formatter.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class RightMenu extends StatelessWidget {
  final GameState state;

  const RightMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const RightMenuTitle(),
          const HorizontalDivider(
            color: Palette.divider1,
            height: 1,
          ),
          for (final event in state.colony.futureEvents)
            RightMenuRow(
              event: event,
              onPressed: () => state.onFutureSelected(event),
            ),
        ],
      ),
    );
  }
}

class RightMenuTitle extends StatelessWidget {
  const RightMenuTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff7a5e00).withAlpha(150),
            Palette.backgroundTransparent1,
          ],
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Label(
          text: 'Upcoming',
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RightMenuRow extends StatelessWidget {
  final FutureEvent event;
  final VoidCallback onPressed;

  const RightMenuRow({
    required this.event,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Palette.backgroundTransparent2,
        child: InkWell(
          hoverColor: Palette.backgroundTransparent1.withAlpha(50),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 35),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  event.icon,
                  size: 12,
                  color: Palette.iconLevel1,
                ),
                const HBox(10),
                Expanded(
                  child: Label(
                    text: event.summary,
                  ),
                ),
                const HBox(10),
                Label(
                  text: Formatter.time(event.remainingTime),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
