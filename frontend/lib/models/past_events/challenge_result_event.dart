import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ChallengeResultEvent extends PastEvent {
  ChallengeResultEvent() : super(eventType: EventType.challenge_result);

  @override
  String get summary => 'Challenge completed';

  @override
  IconData get icon => Icons.check;
}
