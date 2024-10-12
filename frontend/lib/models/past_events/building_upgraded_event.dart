import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class BuildingUpgradedEvent extends PastEvent {
  BuildingUpgradedEvent() : super(eventType: EventType.building_upgraded);

  @override
  String get summary => 'Building upgraded';

  @override
  IconData get icon => Icons.warehouse;
}
