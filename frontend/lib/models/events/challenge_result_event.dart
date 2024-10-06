import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/events/event.dart';
import 'package:godluckwiththat/types/event_type.dart';

class ChallengeResultEvent extends Event {
  ChallengeResultEvent() : super(eventType: EventType.challenge_result);

  @override
  String get summary => 'Challenge completed';

  @override
  IconData get icon => Icons.check;
}
