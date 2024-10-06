import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ResourceLimitReachedEvent extends Event {
  ResourceLimitReachedEvent()
      : super(eventType: EventType.resource_limit_reached);

  @override
  String get summary => 'Resource limit reached';

  @override
  IconData get icon => Icons.water_drop;
}
