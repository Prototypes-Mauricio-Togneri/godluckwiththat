import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class TerritoryLimitReachedEvent extends Event {
  TerritoryLimitReachedEvent() : super(eventType: EventType.territory_limit_reached);

  @override
  String get summary => 'Territory limit reached';

  @override
  IconData get icon => Icons.map;
}
