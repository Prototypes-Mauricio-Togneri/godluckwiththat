import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

class ResearchUpcoming extends Upcoming {
  ResearchUpcoming({required super.remainingTime})
      : super(upcomingType: UpcomingType.research);

  @override
  String get summary => 'Research finished';

  @override
  IconData get icon => Icons.science;
}
