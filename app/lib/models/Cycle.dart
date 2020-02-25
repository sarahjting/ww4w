class Cycle {
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

  int secondsLeft() {
    final int secondsLeft =
        (60 * 25) - DateTime.now().difference(createdAt).inSeconds;
    if (secondsLeft < 0) return 0;
    return secondsLeft;
  }

  String countDowner() {
    int secondsLeft = this.secondsLeft();
    int minutesLeft = (secondsLeft / 60).floor();
    secondsLeft = secondsLeft - minutesLeft * 60;
    return minutesLeft.toString().padLeft(2, "0") +
        ":" +
        secondsLeft.toString().padLeft(2, "0");
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return DateTime(createdAt.year, createdAt.month, createdAt.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  double progress() {
    final double progress =
        DateTime.now().difference(createdAt).inSeconds / (60 * 25);
    if (progress > 1) return 1.0;
    return progress;
  }
}
