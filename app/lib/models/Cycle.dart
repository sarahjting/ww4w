import './Timer.dart';

class Cycle extends Timer {
  final int id;
  final String tag;
  final DateTime createdAt;
  final DateTime endedAt;

  Cycle({this.id, this.tag, this.createdAt, this.endedAt});

  factory Cycle.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    if (json["ID"] == 0) return null;
    return Cycle(
      id: json['ID'],
      tag: json['Tag'],
      createdAt: DateTime.parse(json['CreatedAt']),
      endedAt: DateTime.parse(json['EndedAt']),
    );
  }

  int secondsTotal() {
    return 60 * 25;
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return DateTime(createdAt.year, createdAt.month, createdAt.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }
}
