import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/node_selected.dart';
import 'package:tensionnode/dialog/construct_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/types/menu_mode.dart';
import 'package:tensionnode/types/node_type.dart';

mixin MenuHandler on BaseGameComponent {
  MenuMode _mode = MenuMode.none;
  Node? _selectedNode;

  bool get isBuildingMode => _mode == MenuMode.building;

  bool get isDestroyingMode => _mode == MenuMode.destroying;

  bool get isAddConnectionMode => _mode == MenuMode.add_connection;

  bool get isRemoveConnectionMode => _mode == MenuMode.remove_connection;

  bool get isInSpecialMode =>
      isBuildingMode ||
      isDestroyingMode ||
      isAddConnectionMode ||
      isRemoveConnectionMode;

  void _enableMode(MenuMode newMode, [unselectNode = true]) {
    if (unselectNode) {
      _selectedNode = null;
    }
    _mode = newMode;
    state.notify();
  }

  void disableMode([bool unselectNode = true]) {
    if (unselectNode) {
      _selectedNode = null;
    }
    _mode = MenuMode.none;
    state.notify();
  }

  void openBuildMenu() => _openMenu(name: ConstructMenu.NAME);

  void openMainMenu() => _openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openSettingsMenu() => _openMenu(
        name: SettingsMenu.NAME,
      );

  void _openMenu({
    required String name,
    bool pauseGame = false,
  }) {
    if (!overlays.isActive(name)) {
      if (pauseGame) {
        pauseEngine();
        state.notify();
      }
      overlays.add(name);
    }
  }

  void closeMenu({
    required String name,
    bool resumeGame = false,
  }) {
    if (overlays.isActive(name)) {
      overlays.remove(name);

      if (resumeGame) {
        resumeEngine();
        state.notify();
      }
    }
  }

  void removeMenuComponents() {
    layerNodes.removeComponents(BuildingIndicator);
    layerNodes.removeComponents(NodeSelected);
  }

  T selectedNode<T>() => _selectedNode as T;

  bool get hasNodeSelected => _selectedNode != null;

  bool isNodeSelectedType(Type type) => _selectedNode.runtimeType == type;

  bool isNodeSelected(Node node) => _selectedNode == node;

  bool selectNode(Node node) {
    if (isDestroyingMode) {
      node.destroy();
    } else if (isAddConnectionMode) {
      _addConnection(selectedNode(), node);
    } else if (isRemoveConnectionMode) {
      _removeConnection(selectedNode(), node);
    } else if (!isInSpecialMode) {
      _selectNode(node);
    }

    return true;
  }

  void _addConnection(Node from, Node to) {
    if ((from != to) && (to is Building)) {
      from.addConnection(to);
    }
  }

  void _removeConnection(Node from, Node to) {
    if (from != to) {
      from.removeConnection(to);
    }
  }

  void _selectNode(Node node) {
    _selectedNode = node;
    removeMenuComponents();
    addComponent(NodeSelected(node));
    state.notify();
  }

  void unselectNode() {
    disableMode();
    removeMenuComponents();
  }

  void enableConstructMode() {
    removeMenuComponents();
    disableMode();
    openBuildMenu();
  }

  void enableBuildingMode(NodeType type) {
    _enableMode(MenuMode.building);
    removeMenuComponents();
    addComponent(BuildingIndicator(type: type));
  }

  void enableDestroyingMode() {
    _enableMode(MenuMode.destroying);
    removeMenuComponents();
  }

  void enableAddConnectionMode() {
    _enableMode(MenuMode.add_connection, false);
  }

  void enableRemoveConnectionMode() {
    _enableMode(MenuMode.remove_connection, false);
  }

  void onCancelOperation() {
    if (isBuildingMode) {
      disableMode();
      removeMenuComponents();
    } else if (isDestroyingMode) {
      disableMode();
    } else if (isAddConnectionMode || isRemoveConnectionMode) {
      disableMode(false);
    }
  }
}
