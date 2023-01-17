import 'package:flutter/material.dart';
import 'package:tensionnode/app/tension_node.dart';
import 'package:tensionnode/services/locator.dart';

void main() async {
  await Locator.load();
  runApp(const TensionNode());
}
