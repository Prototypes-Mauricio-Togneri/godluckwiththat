import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/hud/bottom_menu.dart';
import 'package:gatewayguardians/hud/left_menu.dart';
import 'package:gatewayguardians/hud/right_menu.dart';
import 'package:gatewayguardians/hud/top_menu.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/states/game_state.dart';
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
  final GameState state;

  const GameScreen({
    required this.state,
  });

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState gameState = GameState(jsonMatch);

    return GameScreen(state: gameState);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        state.onPop();
        return false;
      },
      child: CustomStatusBar(
        style: SystemUiOverlayStyle.light,
        statusBarColor: Palette.grey,
        child: SafeArea(
          child: Scaffold(
            body: RawKeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKey: state.onKey,
              child: GameLoop(state),
            ),
          ),
        ),
      ),
    );
  }
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
        final double dt = current - previous;
        previous = current;
        widget.state.update(dt);

        return Row(
          children: [
            Container(
              color: Palette.darkGrey,
              width: 300,
              height: double.infinity,
              child: Column(
                children: [
                  LeftMenu(widget.state),
                  const Spacer(),
                  BottomMenu(widget.state),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TopMenu(widget.state),
                  Expanded(child: _menuScreen(widget.state.menuType)),
                ],
              ),
            ),
            RightMenu(widget.state),
          ],
        );
      },
    );
  }

  Widget _menuScreen(MenuType menuType) => switch (menuType) {
        MenuType.headquarters => HeadquartersView(widget.state),
        MenuType.water => WaterView(widget.state),
        MenuType.food => FoodView(widget.state),
        MenuType.wood => WoodView(widget.state),
        MenuType.stone => StoneView(widget.state),
        MenuType.faith => FaithView(widget.state),
        MenuType.warehouse => WarehouseView(widget.state),
        MenuType.market => MarketView(widget.state),
        MenuType.research => ResearchView(widget.state)
      };
}
