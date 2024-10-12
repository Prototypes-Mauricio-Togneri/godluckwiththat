import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/types/future_event_type.dart';

class ChallengeEvent extends FutureEvent {
  ChallengeEvent({required super.remainingTime})
      : super(eventType: FutureEventType.challenge);

  @override
  String get summary => 'Challenge ending';

  @override
  IconData get icon => Icons.church;
}
