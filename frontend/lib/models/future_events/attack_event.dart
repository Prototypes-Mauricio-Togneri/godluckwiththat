import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/types/future_event_type.dart';

class AttackEvent extends FutureEvent {
  AttackEvent({required super.remainingTime})
      : super(eventType: FutureEventType.attack);

  @override
  String get summary => 'Tribe attack arriving';

  @override
  IconData get icon => Icons.security;
}
