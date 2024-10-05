import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class TabbedContainer extends StatefulWidget {
  final List<TabData> tabs;
  final List<Widget> children;

  const TabbedContainer({
    required this.tabs,
    required this.children,
  });

  @override
  State<TabbedContainer> createState() => _TabbedContainerState();
}

class _TabbedContainerState extends State<TabbedContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Header(
          tabs: widget.tabs,
          currentIndex: _currentIndex,
          onTabSelected: onTabSelected,
        ),
        widget.children[_currentIndex],
      ],
    );
  }

  void onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Header extends StatelessWidget {
  final List<TabData> tabs;
  final int currentIndex;
  final Function(int) onTabSelected;

  const Header({
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < tabs.length; i++)
          TabEntry(
            data: tabs[i],
            selected: i == currentIndex,
            onSelected: () => onTabSelected(i),
          ),
      ],
    );
  }
}

class TabEntry extends StatelessWidget {
  final TabData data;
  final bool selected;
  final VoidCallback onSelected;

  const TabEntry({
    required this.data,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Material(
        color: selected ? Colors.blue : Colors.grey,
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  size: 12,
                  color: Palette.white,
                ),
                const HBox(5),
                Label(
                  text: data.title,
                  color: Palette.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabData {
  final String title;
  final IconData icon;

  const TabData({
    required this.title,
    required this.icon,
  });
}
