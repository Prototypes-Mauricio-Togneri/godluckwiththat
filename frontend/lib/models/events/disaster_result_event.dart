import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class DisasterResultEvent extends Event {
  DisasterResultEvent() : super(eventType: EventType.diaster_result);

  @override
  String get summary => 'Earthquake happened';

  @override
  IconData get icon => Icons.warning;
}
