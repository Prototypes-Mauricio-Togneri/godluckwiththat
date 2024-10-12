import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/event_type.dart';

abstract class PastEvent {
  final EventType eventType;

  const PastEvent({required this.eventType});

  String get summary;

  IconData get icon;
}
