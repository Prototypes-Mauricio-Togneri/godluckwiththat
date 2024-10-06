import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/event_type.dart';

abstract class Event {
  final EventType eventType;

  const Event({required this.eventType});

  String get summary;

  IconData get icon;
}
