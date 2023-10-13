
class Rank {
  int rank = -1;
  late String userName;
  late int userId;
  late int score;
  late bool me;
  late DateTime timestamp;

  Rank({
    required this.userName,
    required this.userId,
    required this.score,
    required this.me,
    required this.timestamp
  });

  int getRank() {
    return rank;
  }

  String getUserName() {
    return userName;
  }

  int getScore() {
    return score;
  }

  bool getMe() {
    return me;
  }

  DateTime getTimestamp() {
    return timestamp;
  }

  bool equals(Rank other) {
    return this.rank == other.getRank()
        && this.userName == other.getUserName()
        && this.score == other.getScore()
        && this.me == other.getMe()
        && this.timestamp == other.getTimestamp();
  }

  Rank.fromJson(Map<String, dynamic> json) {
    rank = -1;
    if (json.containsKey("user_name")) {
      userName = json["user_name"];
    }
    if (json.containsKey("score")) {
      score = json["score"];
    }
    if (json.containsKey("timestamp")) {
      timestamp = DateTime.parse(json["timestamp"]);
    }
  }
}