import 'package:flutter/material.dart';
import 'package:godluckwiththat/hud/bottom_menu.dart';
import 'package:godluckwiththat/hud/left_menu.dart';
import 'package:godluckwiththat/hud/right_menu.dart';
import 'package:godluckwiththat/hud/top_menu.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/widgets/misc/game_loop.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GameLoop(state),
    );
  }
}

class GameContent extends StatelessWidget {
  final GameState state;

  const GameContent(this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapView(state),
        Align(
          alignment: Alignment.topCenter,
          child: TopMenu(state),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomMenu(state),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: LeftMenu(state),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RightMenu(state),
        ),
      ],
    );
  }
}

class MapView extends StatelessWidget {
  final GameState state;

  const MapView(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

/*class GameContent extends StatefulWidget {
  final GameState state;

  const GameContent(this.state);

  @override
  State<GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Palette.black,
        unselectedItemColor: Palette.lightGrey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'TOWN CENTER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset),
            label: 'RESOURCES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'MILITARY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'RESEARCH',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Palette.white,
        child: _body(currentIndex),
      ),
    );
  }

  Widget _body(int index) {
    if (currentIndex == 0) {
      return TownCenterView(widget.state);
    } else if (currentIndex == 1) {
      return ResourcesView(widget.state);
    } else if (currentIndex == 2) {
      return MilitaryView(widget.state);
    } else if (currentIndex == 3) {
      return ResearchView(widget.state);
    } else {
      return const Empty();
    }
  }
}
*/