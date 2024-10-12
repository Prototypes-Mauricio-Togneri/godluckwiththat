import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

abstract class PastEvent {
  final PastEventType eventType;

  const PastEvent({required this.eventType});

  String get summary;

  IconData get icon;
}
