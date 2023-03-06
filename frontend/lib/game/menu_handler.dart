import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/node_selected.dart';
import 'package:tensionnode/components/game/headquarters.dart';
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

  bool get isSetConnectionMode => _mode == MenuMode.set_connection;

  bool get isTransferDroneMode => _mode == MenuMode.transfer_drone;

  bool get isCancellable =>
      isBuildingMode ||
      isDestroyingMode ||
      isSetConnectionMode ||
      isTransferDroneMode;

  bool get isInSpecialMode =>
      isBuildingMode ||
      isDestroyingMode ||
      isSetConnectionMode ||
      isTransferDroneMode;

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

  void selectNode(Node node) {
    if (isSetConnectionMode || (isControlPressed && hasNodeSelected)) {
      _toggleConnection(selectedNode(), node);
    } else if (isDestroyingMode) {
      node.destroy(true);
    } else if (isTransferDroneMode) {
      final Node from = selectedNode();
      from.transferDroneTo(node);
    } else if (!isInSpecialMode) {
      _selectNode(node);
    }

    state.notify();
  }

  void _toggleConnection(Node from, Node to) {
    if (from.hasDroneConnection(to)) {
      _removeConnection(from, to);
    } else {
      _addConnection(from, to);
    }
  }

  void _addConnection(Node from, Node to) {
    if ((from != to) && ((to is Building) || (to is Headquarters))) {
      from.addDroneConnection(to);
    }
  }

  void _removeConnection(Node from, Node to) {
    if (from != to) {
      from.removeDroneConnection(to);
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

  void enableSetConnectionMode() {
    _enableMode(MenuMode.set_connection, false);
  }

  void enableTransferDroneMode() {
    _enableMode(MenuMode.transfer_drone, false);
  }

  void onCancelOperation() {
    if (isBuildingMode) {
      disableMode();
      removeMenuComponents();
    } else if (isDestroyingMode) {
      disableMode();
    } else if (isSetConnectionMode || isTransferDroneMode) {
      disableMode(false);
    }
  }
}
