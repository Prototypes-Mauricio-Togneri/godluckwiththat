import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ResearchCompletedEvent extends PastEvent {
  ResearchCompletedEvent() : super(eventType: EventType.research_completed);

  @override
  String get summary => 'Research completed';

  @override
  IconData get icon => Icons.science;
}
