import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class SeasonChangeEvent extends PastEvent {
  SeasonChangeEvent() : super(eventType: PastEventType.season_change_coming);

  @override
  String get summary => 'Winter coming';

  @override
  IconData get icon => Icons.ac_unit;
}
