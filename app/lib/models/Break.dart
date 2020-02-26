import './Timer.dart';

class Break extends Timer {
  final DateTime createdAt;
  Break({this.createdAt});

  int secondsTotal() {
    return 60 * 5;
  }
}
