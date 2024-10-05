import 'package:flutter/material.dart';

class Hovered extends StatefulWidget {
  final Function(BuildContext, bool) builder;

  const Hovered({
    required this.builder,
  });

  @override
  State<Hovered> createState() => _HoveredState();
}

class _HoveredState extends State<Hovered> {
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
      child: widget.builder(context, show),
    );
  }
}
