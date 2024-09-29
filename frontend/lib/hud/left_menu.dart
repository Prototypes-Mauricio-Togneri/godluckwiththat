import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeftMenuTitle(state),
          HorizontalDivider(
            color: Palette.divider1,
            height: 1,
          ),
          LeftMenuRow(
            text: 'Worker created',
            icon: Icons.person,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Winter coming',
            icon: Icons.ac_unit,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Earthquake happened',
            icon: Icons.warning,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Challenge completed',
            icon: Icons.check,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Solider created',
            icon: Icons.security,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Building created',
            icon: Icons.home,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Research completed',
            icon: Icons.science,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Population limit reached',
            icon: Icons.group,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
          LeftMenuRow(
            text: 'Territory slot reached',
            icon: Icons.map,
            onSelected: state.onEventSelected,
            onClosed: state.onEventClosed,
          ),
        ],
      ),
    );
  }
}

class LeftMenuTitle extends StatelessWidget {
  final GameState state;

  const LeftMenuTitle(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff7a5e00).withAlpha(150),
            Palette.backgroundTransparent1,
          ],
        ),
      ),
      child: Row(
        children: [
          const HBox(10),
          Expanded(
            child: Label(
              text: 'Events'.toUpperCase(),
              weight: FontWeight.bold,
            ),
          ),
          const HBox(10),
          Material(
            color: Palette.transparent,
            child: InkWell(
              hoverColor: Palette.backgroundClose.withAlpha(150),
              onTap: state.onCleanAllEvents,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.close,
                  size: 15,
                  color: Palette.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftMenuRow extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onSelected;
  final VoidCallback onClosed;

  const LeftMenuRow({
    required this.text,
    required this.icon,
    required this.onSelected,
    required this.onClosed,
  });

  @override
  State<LeftMenuRow> createState() => _LeftMenuRowState();
}

class _LeftMenuRowState extends State<LeftMenuRow> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        show = true;
      }),
      onExit: (event) => setState(() {
        show = false;
      }),
      child: Material(
        color: Palette.backgroundTransparent2,
        child: InkWell(
          hoverColor: Palette.backgroundTransparent1.withAlpha(50),
          onTap: widget.onSelected,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HBox(10),
              Icon(
                widget.icon,
                size: 12,
                color: Palette.white,
              ),
              const HBox(10),
              Expanded(child: Label(text: widget.text)),
              SizedBox(
                width: 35,
                height: 35,
                child: show
                    ? Material(
                        color: Palette.transparent,
                        child: InkWell(
                          hoverColor: Palette.backgroundClose.withAlpha(150),
                          onTap: widget.onClosed,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.close,
                              size: 15,
                              color: Palette.white,
                            ),
                          ),
                        ),
                      )
                    : const Empty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
