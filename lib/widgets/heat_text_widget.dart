// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:ct_backprojection/functions/responsive.dart';

class HeatTextWidget extends StatelessWidget {
  final List<List<double>> bpArray;
  double? size;
  HeatTextWidget({
    Key? key,
    required this.bpArray,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int arraySize = bpArray[0].length;
    print(arraySize);

    return Column(
        children: List.generate(arraySize,
            (index) => rowContainer(index, arraySize, context, size)));
  }

  Row rowContainer(
      int rowIndex, int arraySize, BuildContext context, double? size) {
    return Row(
      children: List.generate(
        arraySize,
        (index) => Container(
          height: size ?? 100,
          width: size ?? 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.7))),
          child: Center(
              child: Text(
            bpArray[rowIndex][index].toStringAsFixed(3),
            style: TextStyle(
                fontSize: responsiveScreen(context) ? 14 : 18,
                color: Colors.white.withOpacity(0.7)),
          )),
        ),
      ),
    );
  }
}
