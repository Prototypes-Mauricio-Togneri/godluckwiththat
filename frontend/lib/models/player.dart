import 'package:flutter/material.dart';

class Player {
  final String id;
  final Color color;

  static final Color PLAYER_COLOR = Colors.blue[900]!;
  static final Color NEUTRAL_COLOR = Colors.grey[700]!;

  const Player._(this.id, this.color);

  bool get isOwn => id == 'you';

  factory Player.you() => Player._('you', PLAYER_COLOR);

  factory Player.neutral() => Player._('neutral', NEUTRAL_COLOR);
}
