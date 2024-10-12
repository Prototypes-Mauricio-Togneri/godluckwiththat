import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/types/past_event_type.dart';

class ChallengeResultEvent extends PastEvent {
  ChallengeResultEvent() : super(eventType: PastEventType.challenge_result);

  @override
  String get summary => 'Challenge completed';

  @override
  IconData get icon => Icons.check;
}
