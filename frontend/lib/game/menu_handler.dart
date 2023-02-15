import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/node_selected.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/dialog/game_over_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/settings_menu.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/types/menu_mode.dart';
import 'package:tensionnode/types/node_type.dart';

mixin MenuHandler on BaseGameComponent {
  MenuMode _mode = MenuMode.none;
  Node? _selectedNode;

  bool get constructMode => _mode == MenuMode.construct;

  bool get buildingMode => _mode == MenuMode.building;

  bool get destroyingMode => _mode == MenuMode.destroying;

  bool get isDetailsMode =>
      (_mode == MenuMode.construct) || (_mode == MenuMode.node_selected);

  bool get isInSpecialMode =>
      (_mode == MenuMode.building) || (_mode == MenuMode.destroying);

  void _enableMode(MenuMode newMode) {
    _selectedNode = null;
    _mode = newMode;
    state.notify();
  }

  void disableMode() {
    _selectedNode = null;
    _mode = MenuMode.none;
    state.notify();
  }

  void openMainMenu() => _openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openGameOverMenu() => _openMenu(
        name: GameOverMenu.NAME,
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

  bool isSelected(Type type) => _selectedNode.runtimeType == type;

  bool selectNode(Node node) {
    if (destroyingMode && !(node is Headquarters)) {
      node.destroy();
    } else if (!isInSpecialMode) {
      _enableMode(MenuMode.node_selected);
      _selectedNode = node;

      removeMenuComponents();
      addToNodesLayer(NodeSelected(node));
    }

    return true;
  }

  void unselectNode() {
    disableMode();
    removeMenuComponents();
  }

  void enableConstructMode() {
    _enableMode(MenuMode.construct);
    removeMenuComponents();
  }

  void disableConstructMode() => disableMode();

  void enableBuildingMode(NodeType type) {
    _enableMode(MenuMode.building);
    removeMenuComponents();
    addToNodesLayer(BuildingIndicator(type: type));
  }

  void _disableBuildingMode() {
    disableMode();
    removeMenuComponents();
  }

  void enableDestroyingMode() {
    _enableMode(MenuMode.destroying);
    removeMenuComponents();
  }

  void _disableDestroyingMode() => disableMode();

  void onCancelOperation() {
    if (buildingMode) {
      _disableBuildingMode();
    } else if (destroyingMode) {
      _disableDestroyingMode();
    }
  }
}
