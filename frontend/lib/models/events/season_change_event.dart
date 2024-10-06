import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class SeasonChangeEvent extends Event {
  SeasonChangeEvent() : super(eventType: EventType.season_change_coming);

  @override
  String get summary => 'Winter coming';

  @override
  IconData get icon => Icons.ac_unit;
}
