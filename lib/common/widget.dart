class GoalItem {
  String title;
  bool completed;
  GoalItem(this.title, this.completed);
}

class DayData {
  List<GoalItem> dailyGoals;
  int calorieIntake;
  int waterIntake;
  double weight;

  DayData({
    required this.dailyGoals,
    this.calorieIntake = 0,
    this.waterIntake = 0,
    this.weight = 0,
  });
}
