import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/types/future_event_type.dart';

class BuildingUpgradeEvent extends FutureEvent {
  BuildingUpgradeEvent({required super.remainingTime})
      : super(eventType: FutureEventType.building_upgrade);

  @override
  String get summary => 'Building upgrade';

  @override
  IconData get icon => Icons.warehouse;
}
