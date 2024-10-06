import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/event_type.dart';

abstract class Event {
  final EventType eventType;

  const Event({required this.eventType});

  String get summary;

  IconData get icon;
}

class WorkerCreatedEvent extends Event {
  WorkerCreatedEvent() : super(eventType: EventType.worker_created);

  @override
  String get summary => 'Worker created';
  
  @override
  IconData get icon => Icons.person;
}
