import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class TerritoryLimitReachedEvent extends PastEvent {
  TerritoryLimitReachedEvent()
      : super(eventType: PastEventType.territory_limit_reached);

  @override
  String get summary => 'Territory limit reached';

  @override
  IconData get icon => Icons.map;
}
