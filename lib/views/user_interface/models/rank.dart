
class Rank {
  late String userName;
  late int userId;
  late int score;
  bool me = false;
  late DateTime timestamp;

  Rank({
    required this.userName,
    required this.userId,
    required this.score,
    required this.me,
    required this.timestamp
  });

  String getUserName() {
    return userName;
  }

  int getScore() {
    return score;
  }

  bool getMe() {
    return me;
  }

  setMe(bool me) {
    this.me = me;
  }

  DateTime getTimestamp() {
    return timestamp.toLocal();
  }

  int getUserId() {
    return userId;
  }

  bool equals(Rank other) {
    return this.userName == other.getUserName()
        && this.score == other.getScore()
        && this.me == other.getMe()
        && this.timestamp == other.getTimestamp();
  }

  Rank.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("user_name")) {
      userName = json["user_name"];
    }
    if (json.containsKey("user_id")) {
      userId = json["user_id"];
    }
    if (json.containsKey("score")) {
      score = json["score"];
    }
    if (json.containsKey("timestamp")) {
      String timestampString = json["timestamp"];
      if (!timestampString.endsWith("Z")) {
        // The server has utc timestamp, but it's not formatted with the 'Z'.
        timestampString += "Z";
      }
      timestamp = DateTime.parse(timestampString);
    }
  }
}