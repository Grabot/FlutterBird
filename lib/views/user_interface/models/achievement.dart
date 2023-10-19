
class Achievement {

  late String imagePath;
  late String tooltip;

  Achievement({
    required this.imagePath,
    required this.tooltip
  });

  bool equals(Achievement other) {
    return this.imagePath == other.getImagePath()
        && this.tooltip == other.getTooltip();
  }

  getImagePath() {
    return imagePath;
  }

  getTooltip() {
    return tooltip;
  }
}
