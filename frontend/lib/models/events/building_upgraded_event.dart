import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class BuildingUpgradedEvent extends Event {
  BuildingUpgradedEvent() : super(eventType: EventType.building_upgraded);

  @override
  String get summary => 'Building upgraded';

  @override
  IconData get icon => Icons.home;
}
