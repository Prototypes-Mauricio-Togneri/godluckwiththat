import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class PopulationLimitReachedEvent extends PastEvent {
  PopulationLimitReachedEvent()
      : super(eventType: EventType.population_limit_reached);

  @override
  String get summary => 'Population limit reached';

  @override
  IconData get icon => Icons.group;
}
