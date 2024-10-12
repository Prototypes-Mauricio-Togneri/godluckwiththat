import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/future_event_type.dart';

abstract class FutureEvent {
  final FutureEventType eventType;
  num remainingTime;

  FutureEvent({
    required this.eventType,
    required this.remainingTime,
  });

  bool update(double dt) {
    remainingTime -= dt;

    return remainingTime <= 1;
  }

  String get summary;

  IconData get icon;
}
