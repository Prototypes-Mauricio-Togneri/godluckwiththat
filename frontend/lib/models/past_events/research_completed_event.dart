import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class ResearchCompletedEvent extends PastEvent {
  ResearchCompletedEvent() : super(eventType: PastEventType.research_completed);

  @override
  String get summary => 'Research completed';

  @override
  IconData get icon => Icons.science;
}
