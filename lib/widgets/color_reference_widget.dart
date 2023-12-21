import 'package:ct_backprojection/functions/colorGenerator.dart';
import 'package:flutter/material.dart';

class ColorReferenceWidget extends StatelessWidget {
  const ColorReferenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Value Table",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            30,
            (index) => Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    width: 20 + index.toDouble(),
                    color: colorGenerator((index - 30).abs() / 10),
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  width: 50,
                  child: Text(
                    "${(index - 30).abs() / 10}",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
