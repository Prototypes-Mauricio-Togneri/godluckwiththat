import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class PopulationLimitReachedEvent extends PastEvent {
  PopulationLimitReachedEvent()
      : super(eventType: PastEventType.population_limit_reached);

  @override
  String get summary => 'Population limit reached';

  @override
  IconData get icon => Icons.group;
}
