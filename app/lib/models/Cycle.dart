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
}
