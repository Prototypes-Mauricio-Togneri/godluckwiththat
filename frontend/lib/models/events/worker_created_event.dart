import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class WorkerCreatedEvent extends Event {
  WorkerCreatedEvent() : super(eventType: EventType.worker_created);

  @override
  String get summary => 'Worker created';

  @override
  IconData get icon => Icons.person;
}
