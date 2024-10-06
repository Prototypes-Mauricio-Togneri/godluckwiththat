import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ResearchCompletedEvent extends Event {
  ResearchCompletedEvent() : super(eventType: EventType.research_completed);

  @override
  String get summary => 'Research completed';

  @override
  IconData get icon => Icons.science;
}
