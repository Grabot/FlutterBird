
class Achievement {

  late String achievementName;
  late String imageName;
  late String tooltip;
  bool achieved = false;

  Achievement({
    required this.achievementName,
    required this.imageName,
    required this.tooltip,
    required this.achieved,
  });

  @override
  bool operator ==(Object other) {
    if (other is Achievement) {
      return this.achievementName == other.getAchievementName()
          && this.imageName == other.getImagePath()
          && this.tooltip == other.getTooltip()
          && this.achieved == other.getAchieved();
    }
    return false;
  }

  @override
  int get hashCode => achievementName.hashCode ^ imageName.hashCode ^ tooltip.hashCode ^ achieved.hashCode;

  getAchievementName() {
    return achievementName;
  }

  getImagePath() {
    String imagePath = "assets/images/achievements/";
    imagePath += imageName;
    imagePath += ".png";
    return imagePath;
  }

  getTooltip() {
    return tooltip;
  }

  getAchieved() {
    return achieved;
  }
}
