import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/hud/bottom_menu.dart';
import 'package:gatewayguardians/hud/left_menu.dart';
import 'package:gatewayguardians/hud/right_menu.dart';
import 'package:gatewayguardians/hud/top_menu.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/states/menu_state.dart';
import 'package:gatewayguardians/types/menu_type.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/views/faith_view.dart';
import 'package:gatewayguardians/views/food_view.dart';
import 'package:gatewayguardians/views/headquarters_view.dart';
import 'package:gatewayguardians/views/market_view.dart';
import 'package:gatewayguardians/views/research_view.dart';
import 'package:gatewayguardians/views/stone_view.dart';
import 'package:gatewayguardians/views/warehouse_view.dart';
import 'package:gatewayguardians/views/water_view.dart';
import 'package:gatewayguardians/views/wood_view.dart';

class GameScreen extends StatelessWidget {
  final GameState gameState;
  final MenuState menuState;

  const GameScreen({
    required this.gameState,
    required this.menuState,
  });

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState gameState = GameState(jsonMatch);
    final MenuState menuState = MenuState(
      gameState: gameState,
      menuType: MenuType.headquarters,
    );

    return GameScreen(
      gameState: gameState,
      menuState: menuState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        gameState.onPop();
        return false;
      },
      child: CustomStatusBar(
        style: SystemUiOverlayStyle.light,
        statusBarColor: Palette.grey,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GameLoop(gameState),
                RawKeyboardListener(
                  autofocus: true,
                  focusNode: FocusNode(),
                  onKey: gameState.onKey,
                  child: Row(
                    children: [
                      Container(
                        color: Palette.darkGrey,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: StateProvider<MenuState>(
                                state: menuState,
                                builder: (context, state) => LeftMenu(state),
                              ),
                            ),
                            StateProvider<GameState>(
                              state: gameState,
                              builder: (context, state) => BottomMenu(state),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StateProvider<GameState>(
                          state: gameState,
                          builder: (context, state) => Column(
                            children: [
                              TopMenu(gameState),
                              Expanded(child: _menuScreen(gameState.menuType)),
                            ],
                          ),
                        ),
                      ),
                      StateProvider<GameState>(
                        state: gameState,
                        builder: (context, state) => RightMenu(state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuScreen(MenuType menuType) => switch (menuType) {
        MenuType.headquarters => HeadquartersView(gameState),
        MenuType.water => WaterView(gameState),
        MenuType.food => FoodView(gameState),
        MenuType.wood => WoodView(gameState),
        MenuType.stone => StoneView(gameState),
        MenuType.faith => FaithView(gameState),
        MenuType.warehouse => WarehouseView(gameState),
        MenuType.market => MarketView(gameState),
        MenuType.research => ResearchView(gameState)
      };
}

class GameLoop extends StatefulWidget {
  final GameState state;

  const GameLoop(this.state);

  @override
  State<GameLoop> createState() => _GameLoopState();
}

class _GameLoopState extends State<GameLoop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final DateTime _initialTime = DateTime.now();
  double previous = 0;
  double get currentTime =>
      DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;
  double accumulatedDt = 0;

  @override
  void initState() {
    super.initState();
    previous = currentTime;
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double current = currentTime;
        accumulatedDt += current - previous;
        previous = current;

        if (accumulatedDt >= 1) {
          widget.state.update(accumulatedDt);
          accumulatedDt -= 1;
        }

        return const Empty();
      },
    );
  }
}
