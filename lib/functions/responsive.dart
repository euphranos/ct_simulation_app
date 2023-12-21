import 'package:flutter/material.dart';

bool responsiveScreen(BuildContext context) {
  if (MediaQuery.of(context).size.width <= 1100) {
    return true;
  }
  return false;
}
