import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/types/future_event_type.dart';

class ResearchEvent extends FutureEvent {
  ResearchEvent({required super.remainingTime})
      : super(eventType: FutureEventType.research);

  @override
  String get summary => 'Research finished';

  @override
  IconData get icon => Icons.science;
}
