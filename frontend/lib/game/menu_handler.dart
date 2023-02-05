import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node_selected.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/dialog/global/main_menu.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';

mixin MenuHandler on BaseGameComponent {
  void openMainMenu() => openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openMenu({
    required String name,
    bool pauseGame = false,
  }) {
    if (!overlays.isActive(name)) {
      if (pauseGame) {
        pauseEngine();
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
      }
    }
  }

  void removeMenuComponents() {
    removeComponents(BuildingIndicator);
    removeComponents(NodeSelected);
  }

  bool selectNode(FixedNode node) {
    if (state.destroyingMode && !(node is Kernel)) {
      node.destroy();
    } else if (!state.isInSpecialMode) {
      state.selectNode(node);
      removeMenuComponents();
      add(NodeSelected(node: node));
    }

    return true;
  }

  void unselectNode() {
    state.unselectNode();
    removeMenuComponents();
  }

  void enableConstructMode() {
    state.enableConstructMode();
    removeMenuComponents();
  }

  void disableConstructMode() => state.disableConstructMode();

  void enableBuildingMode(FixedNodeSpec spec) {
    state.enableBuildingMode();
    removeMenuComponents();
    add(BuildingIndicator(spec: spec));
  }

  void _disableBuildingMode() {
    state.disableBuildingMode();
    removeMenuComponents();
  }

  void enableDestroyingMode() {
    state.enableDestroyingMode();
    removeMenuComponents();
  }

  void _disableDestroyingMode() {
    state.disableDestroyingMode();
  }

  void onCancelOperation() {
    if (state.buildingMode) {
      _disableBuildingMode();
    } else if (state.destroyingMode) {
      _disableDestroyingMode();
    }
  }
}
