import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ResourceLimitReachedEvent extends PastEvent {
  ResourceLimitReachedEvent()
      : super(eventType: EventType.resource_limit_reached);

  @override
  String get summary => 'Resource limit reached';

  @override
  IconData get icon => Icons.water_drop;
}
