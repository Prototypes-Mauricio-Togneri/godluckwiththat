import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Trainer extends Building {
  final ResourceType resourceType;

  Trainer({
    required this.resourceType,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  int get resources;

  int get capacity => level * 100;

  @override
  bool get isTrainer => true;

  void train() {}
}
