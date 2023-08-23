import 'package:godluckwiththat/types/patch_type.dart';

class Patch {
  final PatchType patchType;
  final int amount;

  const Patch({
    required this.patchType,
    required this.amount,
  });
}
