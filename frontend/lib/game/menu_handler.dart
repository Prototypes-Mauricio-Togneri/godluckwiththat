import 'package:tensionplanet/components/base/building.dart';
import 'package:tensionplanet/components/base/building_indicator.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/base/node_selected.dart';
import 'package:tensionplanet/components/game/warehouse.dart';
import 'package:tensionplanet/dialog/choose_resource_menu.dart';
import 'package:tensionplanet/dialog/construct_menu.dart';
import 'package:tensionplanet/dialog/main_menu.dart';
import 'package:tensionplanet/dialog/settings_menu.dart';
import 'package:tensionplanet/extensions/component_extension.dart';
import 'package:tensionplanet/game/base_game_component.dart';
import 'package:tensionplanet/types/menu_mode.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/toast.dart';

mixin MenuHandler on BaseGameComponent {
  MenuMode _mode = MenuMode.none;
  Node? _selectedNode;

  bool get isBuildingMode => _mode == MenuMode.building;

  bool get isDestroyingMode => _mode == MenuMode.destroying;

  bool get isCancellable => isBuildingMode || isDestroyingMode;

  bool get isInSpecialMode => isBuildingMode || isDestroyingMode;

  void _enableMode(MenuMode newMode, [unselectNode = true]) {
    if (unselectNode) {
      _selectedNode = null;
    }
    _mode = newMode;
    state.notify();
  }

  void disableMode() {
    _selectedNode = null;
    _mode = MenuMode.none;
    state.notify();
  }

  void openChoseResourceMenu() => _openMenu(name: ChooseResourceMenu.NAME);

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

  T selectedNode<T extends Node>() => _selectedNode as T;

  bool get hasNodeSelected => _selectedNode != null;

  bool isNodeSelectedType(Type type) => _selectedNode.runtimeType == type;

  bool isNodeSelected(Node node) => _selectedNode == node;

  void selectNode(Node node) {
    if (isDestroyingMode) {
      node.destroy(
        sendDronesBack: true,
        resourcesBack: node.nodeType.cost,
      );
    } else if (isControlPressed && hasNodeSelected) {
      _toggleConnection(selectedNode(), node);
    } else if (!isInSpecialMode) {
      _selectNode(node);
    }

    state.notify();
  }

  void _toggleConnection(Node from, Node to) {
    if ((from != to) &&
        (from.isBuilding || from.isWarehouse) &&
        to.isBuildingOrHeadquartersOrWareHouse) {
      if (from.hasConnection(to)) {
        from.removeDroneConnection(to);
      } else {
        if (to.isHeadquarters) {
          from.addDroneConnection(to);
        } else {
          final ResourceType resourceType = from.outputType;

          if (to is Building) {
            if (to.canReceiveFrom(resourceType)) {
              from.addDroneConnection(to);
            } else {
              Toast.show(
                  "Target building doesn't accept ${resourceType.toString()}");
            }
          } else if (to is Warehouse) {
            if (to.canReceiveFrom(resourceType)) {
              from.addDroneConnection(to);
            } else {
              Toast.show(
                  "Target warehouse doesn't accept ${resourceType.toString()}");
            }
          }
        }
      }
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

  void enableBuildingMode({
    required NodeType nodeType,
    ResourceType? resourceType,
  }) {
    _enableMode(MenuMode.building);
    removeMenuComponents();
    addComponent(BuildingIndicator(
      nodeType: nodeType,
      resourceType: resourceType,
    ));
  }

  void enableDestroyingMode() {
    _enableMode(MenuMode.destroying);
    removeMenuComponents();
  }

  void onCancelOperation() {
    if (isBuildingMode) {
      disableMode();
      removeMenuComponents();
    } else if (isDestroyingMode) {
      disableMode();
    }
  }
}
