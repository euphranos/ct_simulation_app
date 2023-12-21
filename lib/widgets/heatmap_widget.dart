// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:ct_backprojection/functions/colorGenerator.dart';
import 'package:ct_backprojection/functions/responsive.dart';

class HeatMapWidget extends StatelessWidget {
  final List<List<double>> bpArray;
  double? size;
  HeatMapWidget({
    Key? key,
    required this.bpArray,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int arraySize = bpArray[0].length;
    print(arraySize);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            arraySize, (index) => rowContainer(index, arraySize, context)));
  }

  Row rowContainer(int rowIndex, int arraySize, BuildContext context) {
    return Row(
      children: List.generate(
        arraySize,
        (index) => Container(
          height: responsiveScreen(context) ? 50 : size ?? 100,
          width: responsiveScreen(context) ? 50 : size ?? 100,
          decoration: BoxDecoration(
              color: colorGenerator(bpArray[rowIndex][index]),
              border: Border.all(color: Colors.white.withOpacity(0.7))),
        ),
      ),
    );
  }
}
