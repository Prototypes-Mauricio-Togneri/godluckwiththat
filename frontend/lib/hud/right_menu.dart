import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/event.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/empty_text.dart';
import 'package:godluckwiththat/widgets/label.dart';

class RightMenu extends StatelessWidget {
  final GameState state;

  const RightMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.darkGrey,
      width: 300,
      height: double.infinity,
      child: Column(
        children: [
          const VBox(20),
          const Label(
            text: 'Events',
            color: Palette.white,
            size: 40,
          ),
          if (state.colony.events.isNotEmpty)
            EventsList(state)
          else ...[
            const Spacer(),
            const EmptyText('No events'),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}

class EventsList extends StatelessWidget {
  final GameState state;

  const EventsList(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final Event event in state.colony.events) EventBlock(event),
      ],
    );
  }
}

class EventBlock extends StatelessWidget {
  final Event event;

  const EventBlock(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Palette.lightGrey,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 15,
                right: 15,
              ),
              child: Label(
                text: event.title,
                size: 25,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.close,
              color: Palette.lightGrey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
