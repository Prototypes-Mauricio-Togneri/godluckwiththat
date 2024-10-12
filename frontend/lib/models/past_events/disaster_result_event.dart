import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class DisasterResultEvent extends PastEvent {
  DisasterResultEvent() : super(eventType: PastEventType.diaster_result);

  @override
  String get summary => 'Earthquake happened';

  @override
  IconData get icon => Icons.warning;
}
