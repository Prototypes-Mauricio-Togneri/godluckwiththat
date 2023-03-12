import 'package:motion_toast/motion_toast.dart';
import 'package:tensionplanet/utils/navigation.dart';
import 'package:tensionplanet/widgets/label.dart';

class Toast {
  static void show(String message) {
    MotionToast.error(
      description: Label(text: message),
      toastDuration: const Duration(seconds: 5),
    ).show(Navigation.context);
  }
}
