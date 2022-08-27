import 'package:flutter/widgets.dart';

extension OffsetExtension on Offset {
  bool isAlignedWith(Offset offset) => (offset != this) && ((offset.dx == dx) || (offset.dy == dy));
}
