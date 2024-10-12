import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class BuildingUpgradedEvent extends PastEvent {
  BuildingUpgradedEvent() : super(eventType: PastEventType.building_upgraded);

  @override
  String get summary => 'Building upgraded';

  @override
  IconData get icon => Icons.warehouse;
}
