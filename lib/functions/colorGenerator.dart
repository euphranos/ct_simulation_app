import 'package:flutter/material.dart';

Color colorGenerator(double value) {
  if (value < 1.0) {
    // 1 ile 1.6 arası koyu mavi
    return Color.lerp(Colors.blue, Colors.lightBlue, (value - 1.0) / 0.6)!;
  } else if (value < 1.8) {
    // 1.6 ile 1.8 arası açık mavi
    return Color.lerp(
        Colors.lightBlue, Colors.lightGreen, (value - 1.6) / 0.2)!;
  } else if (value < 2.0) {
    // 1.8 ile 2 arası açık yeşil
    return Color.lerp(Colors.lightGreen, Colors.green, (value - 1.8) / 0.2)!;
  } else if (value < 2.2) {
    // 2 ile 2.2 arası koyu yeşil
    return Color.lerp(Colors.green, Colors.yellow, (value - 2.0) / 0.2)!;
  } else if (value < 2.4) {
    // 2.2 ile 2.4 arası sarı
    return Color.lerp(Colors.yellow, Colors.orange, (value - 2.2) / 0.2)!;
  } else if (value < 2.6) {
    // 2.4 ile 2.6 arası koyu turuncu
    return Color.lerp(Colors.orange, Colors.red, (value - 2.4) / 0.2)!;
  } else if (value < 2.8) {
    // 2.6 ile 2.8 arası kırmızı
    return Color.lerp(Colors.red, Colors.deepOrange, (value - 2.6) / 0.2)!;
  } else {
    // 2.8 ve üstü koyu kırmızı
    return Color(0xff9F0100);
  }
}
