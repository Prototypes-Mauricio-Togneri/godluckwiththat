import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class DisasterResultEvent extends PastEvent {
  DisasterResultEvent() : super(eventType: EventType.diaster_result);

  @override
  String get summary => 'Earthquake happened';

  @override
  IconData get icon => Icons.warning;
}
