import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class MilitaryUnitCreatedEvent extends Event {
  MilitaryUnitCreatedEvent() : super(eventType: EventType.military_unit_created);

  @override
  String get summary => 'Solider created';

  @override
  IconData get icon => Icons.security;
}
