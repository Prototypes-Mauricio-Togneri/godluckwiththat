import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/hud/bottom_menu.dart';
import 'package:godluckwiththat/hud/left_menu.dart';
import 'package:godluckwiththat/hud/right_menu.dart';
import 'package:godluckwiththat/hud/top_menu.dart';
import 'package:godluckwiththat/json/json_match.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/menu_type.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/views/faith_view.dart';
import 'package:godluckwiththat/views/food_view.dart';
import 'package:godluckwiththat/views/headquarters_view.dart';
import 'package:godluckwiththat/views/market_view.dart';
import 'package:godluckwiththat/views/research_view.dart';
import 'package:godluckwiththat/views/stone_view.dart';
import 'package:godluckwiththat/views/warehouse_view.dart';
import 'package:godluckwiththat/views/water_view.dart';
import 'package:godluckwiththat/views/wood_view.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen({
    required this.state,
  });

  factory GameScreen.instance(JsonMatch jsonMatch) {
    final GameState state = GameState(jsonMatch);

    return GameScreen(state: state);
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
        widget.state.update(dt / Constants.SECONDS_PER_DAY);

        return GameContent(widget.state);
      },
    );
  }
}

class GameContent extends StatelessWidget {
  final GameState state;

  const GameContent(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Palette.darkGrey,
          width: 300,
          height: double.infinity,
          child: Column(
            children: [
              LeftMenu(state),
              const Spacer(),
              BottomMenu(state),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TopMenu(state),
              Expanded(
                child: _menuScreen(state.menuType),
              ),
            ],
          ),
        ),
        RightMenu(state),
      ],
    );
  }

  Widget _menuScreen(MenuType menuType) => switch (menuType) {
        MenuType.headquarters => HeadquartersView(state),
        MenuType.water => WaterView(state),
        MenuType.food => FoodView(state),
        MenuType.wood => WoodView(state),
        MenuType.stone => StoneView(state),
        MenuType.faith => FaithView(state),
        MenuType.warehouse => WarehouseView(state),
        MenuType.market => MarketView(state),
        MenuType.research => ResearchView(state)
      };
}
