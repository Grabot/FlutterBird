
class Achievement {

  late String imageName;
  late String tooltip;
  bool achieved = false;

  Achievement({
    required this.imageName,
    required this.tooltip,
    required this.achieved,
  });

  bool equals(Achievement other) {
    return this.imageName == other.getImagePath()
        && this.tooltip == other.getTooltip()
        && this.achieved == other.getAchieved();
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
