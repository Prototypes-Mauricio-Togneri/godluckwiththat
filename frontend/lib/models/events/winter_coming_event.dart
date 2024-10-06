import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class WinterComingEvent extends Event {
  WinterComingEvent() : super(eventType: EventType.winter_coming);

  @override
  String get summary => 'Winter coming';

  @override
  IconData get icon => Icons.ac_unit;
}
