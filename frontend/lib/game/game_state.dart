import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  int version = 0;
  String id = '';
  Resources resources = Resources();

  Node? _selectedNode;
  bool _buildMode = false;
  bool _deleteMode = false;

  bool get showCancel => _buildMode || _deleteMode;

  bool get buildMode => _buildMode;

  bool get deleteMode => _deleteMode;

  void load(JsonMatch jsonMatch) {
    version = jsonMatch.version;
    id = jsonMatch.id;
    resources = Resources(
      red: jsonMatch.resources.red,
      green: jsonMatch.resources.green,
      blue: jsonMatch.resources.blue,
    );
  }

  T selectedNode<T>() => _selectedNode as T;

  void selectNode(Node node) => _selectedNode = node;

  void enableBuildMode() {
    _buildMode = true;
    notify();
  }

  void disableBuildMode() {
    _buildMode = false;
    notify();
  }

  void enableDeleteMode() {
    _deleteMode = true;
    notify();
  }

  void disableDeleteMode() {
    _deleteMode = false;
    notify();
  }

  void addResource(ResourceType type) => resources.add(type);
}
