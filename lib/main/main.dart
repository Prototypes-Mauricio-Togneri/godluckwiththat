import 'package:flutter/material.dart';
import 'package:tensionnode/app/tension_node.dart';
import 'package:tensionnode/services/initializer.dart';

void main() async {
  await Initializer.load();
  runApp(const TensionNode());
}
