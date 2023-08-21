import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
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
          const VBox(10),
          const Label(
            text: 'Events',
            color: Palette.white,
            size: 40,
          ),
          const VBox(10),
          EventsList(state),
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
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        EventBlock(text: 'Farm depleted'),
        EventBlock(text: 'Villager created'),
        EventBlock(text: 'Exploration finished'),
      ],
    );
  }
}

class EventBlock extends StatelessWidget {
  final String text;

  const EventBlock({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(bottom: 10),
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
                text: text,
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
