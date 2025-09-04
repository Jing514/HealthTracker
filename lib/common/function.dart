
double calculateCalorieRequirement(String gender, String weight, String height, String age) {
  double bmr;
  if (gender.toLowerCase() == "male") {
    bmr = 66.47 + (13.75 * double.parse(weight)) + (5.003 * double.parse(height)) - (6.755 * double.parse(age));
    return 1.2*bmr;
  } else {
    bmr = 655.1 + (9.563 * double.parse(weight)) + (1.850 * double.parse(height)) - (4.676 * double.parse(age));
    // print(bmr);
    return 1.2*bmr;
  }
}

double calculateWaterRequirement(String weight){
  double waterR;
  waterR = double.parse(weight) * 35;
  // 35ml of water per kg of weight
  return waterR;
}
