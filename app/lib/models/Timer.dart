abstract class Timer {
  DateTime createdAt;

  int secondsTotal();

  int secondsElapsed() {
    return DateTime.now().difference(createdAt).inSeconds;
  }

  int secondsLeft() {
    int remaining = secondsTotal() - secondsElapsed();
    if (remaining < 0) return 0;
    return remaining;
  }

  String countDowner() {
    int secondsLeft = this.secondsLeft();
    int minutesLeft = (secondsLeft / 60).floor();
    secondsLeft = secondsLeft - minutesLeft * 60;
    return minutesLeft.toString().padLeft(2, "0") +
        ":" +
        secondsLeft.toString().padLeft(2, "0");
  }

  double progress() {
    final double progress = secondsElapsed() / secondsTotal();
    if (progress > 1) return 1.0;
    return progress;
  }
}
