import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/resource.dart';

class Connection {
  final Node to;
  Resource? resource;
  double progress = 0;

  Connection(this.to);
}
