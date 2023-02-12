import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tensionnode/app/tension_node.dart';
import 'package:tensionnode/services/crash_reporter.dart';
import 'package:tensionnode/services/locator.dart';

Future main() async {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const TensionNode());
  }, CrashReporter.onError);
}
