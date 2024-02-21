import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class TasksBlock extends StatelessWidget {
  final List<Task> tasks;

  const TasksBlock({
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Empty();
    } else {
      final Task firstTask = tasks.first;

      return Container(
        width: 40,
        height: 40,
        color: Palette.lightGrey,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Label(
                  text: '${tasks.length}',
                  color: Palette.black,
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 40,
                height: 40 - (40 * firstTask.progress),
                color: const Color(0x33000000),
              ),
            )
          ],
        ),
      );
    }
  }
}
