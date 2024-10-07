import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

class ChallengeUpcoming extends Upcoming {
  ChallengeUpcoming({required super.remainingTime})
      : super(upcomingType: UpcomingType.challenge);

  @override
  String get summary => 'Challenge ending';

  @override
  IconData get icon => Icons.church;
}
