import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/models/resource.dart';

class Connection {
  final Node to;
  Resource? resource;
  double progress = 0;

  Connection(this.to);
}
