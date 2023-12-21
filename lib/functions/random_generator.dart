import 'dart:math';

double generateRandomValue(double minValue, double maxValue) {
  Random random = Random();
  return minValue + random.nextDouble() * (maxValue - minValue);
}
