import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/views/headquarters_view.dart';
import 'package:godluckwiththat/views/military_view.dart';
import 'package:godluckwiththat/views/research_view.dart';
import 'package:godluckwiththat/views/resources_view.dart';
import 'package:godluckwiththat/widgets/misc/game_container.dart';
import 'package:godluckwiththat/widgets/misc/game_loop.dart';

class GameScreen extends StatelessWidget {
  final GameState state;

  const GameScreen(this.state);

  factory GameScreen.instance() => GameScreen(GameState());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GameContainer(
        child: GameLoop(state),
      ),
    );
  }
}

class GameContent extends StatefulWidget {
  final GameState state;

  const GameContent(this.state);

  @override
  State<GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<GameContent> {
  int currentIndex = 0;

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
            label: 'Headquarters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Military',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Research',
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
      return HeadquartersView(widget.state);
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
