import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class ResourceLimitReachedEvent extends PastEvent {
  ResourceLimitReachedEvent()
      : super(eventType: PastEventType.resource_limit_reached);

  @override
  String get summary => 'Resource limit reached';

  @override
  IconData get icon => Icons.water_drop;
}
