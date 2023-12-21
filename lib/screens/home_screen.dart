import 'dart:math';
import 'package:ct_backprojection/functions/line_functions.dart';
import 'package:ct_backprojection/functions/responsive.dart';
import 'package:ct_backprojection/functions/snack_bar.dart';
import 'package:ct_backprojection/widgets/color_reference_widget.dart';
import 'package:ct_backprojection/widgets/custom_button.dart';
import 'package:ct_backprojection/widgets/heat_text_widget.dart';
import 'package:ct_backprojection/widgets/heatmap_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<List<double>> bpArray =
      List.generate(4, (index) => List<double>.filled(4, 0.0));
  List<List<double>> resulBackprojectedArray =
      List.generate(4, (index) => List<double>.filled(4, 0.0));

  late List<List<double>> generatedList;
  int? degreeSampleCount;
  int? beamCount;
  int? intervalTime;
  bool isBusy = false;

  List<List<double>> resultBlurredArray =
      List.generate(4, (index) => List<double>.filled(4, 0.0));

  @override
  void initState() {
    super.initState();

    bpArray[0][0] = 3;
    bpArray[0][1] = 3;
    bpArray[0][2] = 1;
    bpArray[0][3] = 1;

    //
    bpArray[1][0] = 1;
    bpArray[1][1] = 3;
    bpArray[1][2] = 3;
    bpArray[1][3] = 3;
    //
    bpArray[2][0] = 3;
    bpArray[2][1] = 3;
    bpArray[2][2] = 1;
    bpArray[2][3] = 3;
    //
    bpArray[3][0] = 1;
    bpArray[3][1] = 3;
    bpArray[3][2] = 3;
    bpArray[3][3] = 1;
  }

  TextEditingController _arraySizeController = TextEditingController();
  TextEditingController _beamCountController = TextEditingController();
  TextEditingController _angleController = TextEditingController();
  TextEditingController _intervalController = TextEditingController();
  int tapScanStepByStep = 0;
  void onayla() {
    _arraySizeController.text = 4.toString();
    if (_arraySizeController.text.isEmpty) {
      return;
    }
    try {
      int.parse(_arraySizeController.text);
    } catch (e) {
      showSnackBar(context, "You cannot enter invalid value!");
      return;
    }
    //resulBackprojectedArray.clear();
    resulBackprojectedArray =
        List.generate(4, (index) => List<double>.filled(4, 0.0));
    tappedCount = 0;
    int selectedSize = int.parse(_arraySizeController.text);
    if (selectedSize > 6) {
      showSnackBar(context, "You cannot enter above 6 size matrix");
      return;
    }
    if (selectedSize <= 1) {
      showSnackBar(context, "You cannot enter invalid value!");
      return;
    }

    for (int i = 0; i < int.parse(_arraySizeController.text); i++) {
      for (int j = 0; j < int.parse(_arraySizeController.text); j++) {
        bpArray[i][j] = Random().nextBool() ? 1 : 3;
      }

      setState(() {});
    }

    showOkeySnackBar(context, "Image is created successfully! ");
  }

  bool checkDegreeSampleAndBeamCount() {
    if (_beamCountController.text.isEmpty ||
        _angleController.text.isEmpty ||
        _intervalController.text.isEmpty) {
      showSnackBar(context, "You have enter parameters!");
      return false;
    }
    try {
      degreeSampleCount = int.parse(_beamCountController.text.trim());
      beamCount = int.parse(_angleController.text.trim());
      intervalTime = int.parse(_intervalController.text.trim());
    } catch (e) {
      showSnackBar(context, "You cannot enter invalid value!");
      return false;
    }

    if (degreeSampleCount == 0) {
      showSnackBar(context, "You cannot enter zero for scanning angle!");
      return false;
    }
    if (beamCount == 0) {
      showSnackBar(context, "You cannot enter zero for X-Ray beams!");
      return false;
    }
    if (intervalTime == 0) {
      showSnackBar(
          context, "You cannot enter zero for Rotation Interval Time! ");
      return false;
    }
    return true;
  }

  int tappedCount = 0;
  int time = 0;
  bool showAnimation = false;
  double angle = 0;
  void reset() {
    setState(() {
      tappedCount = 0;
      tapScanStepByStep = 0;
      angle = 0;
    });
    resulBackprojectedArray =
        List.generate(4, (index) => List<double>.filled(4, 0.0));
    _angleController.clear();
    _intervalController.clear();
    _beamCountController.clear();
    beamCount = null;
    degreeSampleCount = null;
    intervalTime = null;
  }

  void timerStart() async {
    setState(() {
      showAnimation = true;
    });
    setState(() {
      time = 3;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      time = 2;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      time = 1;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      time = 0;
    });
    setState(() {
      showAnimation = false;
    });
  }

  Future<void> intervalStart() async {
    await Future.delayed(Duration(milliseconds: intervalTime!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181818),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Expanded(
                        //     flex: 2,
                        //     child: TextFormField(
                        //       controller: _arraySizeController,
                        //       style: TextStyle(
                        //           color: Colors.white.withOpacity(0.8)),
                        //       decoration: InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           hintStyle: TextStyle(
                        //               color: Colors.white.withOpacity(0.8)),
                        //           hintText: "ENTER MATRIS SIZE"),
                        //   )),
                        // Spacer(),
                        Expanded(
                          flex: responsiveScreen(context) ? 4 : 2,
                          child: CustomButton(
                            color: Color(0xff2F5D38),
                            buttonText: "CREATE RANDOM IMAGE",
                            onTap: () {
                              onayla();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  //rotation widget test

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      responsiveScreen(context) ? SizedBox() : Spacer(),
                      Expanded(
                        flex: 15,
                        child: Container(
                            padding: responsiveScreen(context)
                                ? const EdgeInsets.all(10)
                                : const EdgeInsets.all(40),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xff1F1F1F),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Image",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    HeatMapWidget(
                                        size: getSize(), bpArray: bpArray),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            )),
                      ),
                      responsiveScreen(context) ? SizedBox() : Spacer(),
                      responsiveScreen(context)
                          ? SizedBox()
                          : Expanded(
                              flex: 5,
                              child: Container(
                                  padding: const EdgeInsets.all(40),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xff1F1F1F),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                  child: ColorReferenceWidget()),
                            ),
                    ],
                  ),
                  !responsiveScreen(context)
                      ? SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(40),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff1F1F1F),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.8)),
                          ),
                          child: ColorReferenceWidget()),
                  SizedBox(height: 80),

                  ResponsiveRowColumn(
                    layout: MediaQuery.of(context).size.width <= 1100
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    rowSpacing: 20,
                    columnSpacing: 20,
                    children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.6))),
                          child: TextFormField(
                            controller: _beamCountController,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              label:
                                  Text("Enter the number of beams for CT scan"),
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                          ),
                        ),
                      ),
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.6))),
                            child: TextFormField(
                              controller: _intervalController,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hoverColor: Colors.purple,
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                label: Text("Rotation Interval (milliseconds)"),
                              ),
                            ),
                          )),
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.6))),
                            child: TextFormField(
                              controller: _angleController,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hoverColor: Colors.purple,
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                label: Text(
                                    "Enter the scanning angle interval in degree"),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 50),
                  ResponsiveRowColumn(
                    layout: MediaQuery.of(context).size.width <= 1100
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    rowSpacing: 20,
                    columnSpacing: 20,
                    children: [
                      isBusy
                          ? ResponsiveRowColumnItem(child: SizedBox())
                          : ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: CustomButton(
                                color: Color(0xffB84C4B),
                                buttonText: "RESET",
                                onTap: () async {
                                  reset();
                                },
                              ),
                            ),
                      tappedCount == 0 && tapScanStepByStep == 0
                          ? ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: CustomButton(
                                color: Color(0xff3498db),
                                buttonText: "SCAN",
                                onTap: () async {
                                  bool checkValue =
                                      checkDegreeSampleAndBeamCount();

                                  if (checkValue &&
                                      tappedCount == 0 &&
                                      tapScanStepByStep == 0) {
                                    setState(() {
                                      isBusy = true;
                                      -tapScanStepByStep++;
                                    });
                                    degreeSampleCount =
                                        int.parse(_angleController.text.trim());
                                    beamCount = int.parse(
                                        _beamCountController.text.trim());

                                    for (double i = 0;
                                        i < 180;
                                        i += degreeSampleCount!) {
                                      angle = i;
                                      setState(() {});
                                      scanForAllBeamsForOneDegree(i);
                                      await intervalStart();

                                      for (int i = 0;
                                          i < resulBackprojectedArray.length;
                                          i++) {
                                        for (int j = 0;
                                            j < resulBackprojectedArray.length;
                                            j++) {
                                          resultBlurredArray[i][j] =
                                              resulBackprojectedArray[i][j] /
                                                  7200;
                                        }
                                      }
                                    }
                                    setState(() {
                                      isBusy = false;
                                    });
                                  }
                                },
                              ),
                            )
                          : ResponsiveRowColumnItem(child: SizedBox()),
                      // tappedCount == 0 && tapScanStepByStep == 0
                      //     ? ResponsiveRowColumnItem(
                      //         rowFlex: 1,
                      //         child: CustomButton(
                      //           color: Color(0xff3498db),
                      //           buttonText: "SCAN",
                      //           onTap: () {
                      //             bool checkValue =
                      //                 checkDegreeSampleAndBeamCount();

                      //             if (checkValue &&
                      //                 tappedCount == 0 &&
                      //                 tapScanStepByStep == 0) {
                      //               timerStart();

                      //               degreeSampleCount =
                      //                   int.parse(_angleController.text.trim());
                      //               beamCount = int.parse(
                      //                   _beamCountController.text.trim());
                      //               if (tappedCount == 0) {
                      //                 for (double i = 0;
                      //                     i < 180;
                      //                     i += degreeSampleCount!) {
                      //                   scanForAllBeamsForOneDegree(i);
                      //                 }

                      //                 for (int i = 0;
                      //                     i < resulBackprojectedArray.length;
                      //                     i++) {
                      //                   for (int j = 0;
                      //                       j < resulBackprojectedArray.length;
                      //                       j++) {
                      //                     resultBlurredArray[i][j] =
                      //                         resulBackprojectedArray[i][j] /
                      //                             7200;
                      //                   }
                      //                 }
                      //               }
                      //               setState(() {
                      //                 tappedCount++;
                      //               });
                      //             }
                      //           },
                      //         ),
                      //       )
                      //     : ResponsiveRowColumnItem(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 40),
                  MediaQuery.of(context).size.width <= 600
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                ),
                                Positioned(
                                  left: 140,
                                  top: 20,
                                  child: HeatMapWidget(
                                    size: 40,
                                    bpArray: bpArray,
                                  ),
                                ),
                                Container(
                                  child: Transform.rotate(
                                    angle: -(angle) * (pi / 180),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    16,
                                                    (index) => Container(
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow
                                                            .withOpacity(0.4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    angle % 4 ==
                                                                            0
                                                                        ? 0.5
                                                                        : 0.8),
                                                            blurRadius: 15,
                                                            offset:
                                                                Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      height: 2,
                                                      margin: EdgeInsets.only(
                                                          top: 7),
                                                    ),
                                                  )),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 200,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.2))),
                                                ),
                                                const SizedBox(width: 5),
                                                Transform.rotate(
                                                  angle: (angle) * (pi / 180),
                                                  child: Text(
                                                    "Detector",
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  tapScanStepByStep >= 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Current Scanning\n Angle: $angle",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: responsiveScreen(context) ? 20 : 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  const SizedBox(height: 10),
                  tappedCount >= 1 || tapScanStepByStep >= 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: responsiveScreen(context)
                                    ? const EdgeInsets.all(10)
                                    : const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xff1F1F1F),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.8)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Scanning Result",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: responsiveScreen(context)
                                              ? 15
                                              : 30,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              HeatTextWidget(
                                                  size: getSize(),
                                                  bpArray:
                                                      resulBackprojectedArray),
                                              responsiveScreen(context)
                                                  ? SizedBox()
                                                  : const SizedBox(width: 50),
                                              responsiveScreen(context)
                                                  ? SizedBox()
                                                  : HeatMapWidget(
                                                      size: getSize(),
                                                      bpArray:
                                                          resultBlurredArray),
                                            ],
                                          ),
                                          responsiveScreen(context)
                                              ? SizedBox(height: 20)
                                              : SizedBox(),
                                          !responsiveScreen(context)
                                              ? SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    HeatMapWidget(
                                                        bpArray:
                                                            resultBlurredArray),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CT SCAN APP",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: responsiveScreen(context) ? 16 : 22,
                  ),
                ),
                Text(
                  "YUSUF GULMEZ ",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: responsiveScreen(context) ? 16 : 22,
                  ),
                ),
              ],
            ),
          ),
          showAnimation
              ? Container(
                  color: Colors.black.withOpacity(0.95),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SCANNING...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$time",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Image(
                            image: AssetImage(
                          "assets/ske.gif",
                        )),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void scanForAllBeamsForOneDegree(double degree) {
    var beams = generateBeams(beamCount!);

    for (var element in beams) {
      var newCoords = calculateNewCoordinate(degree, element[0], element[1]);
      List<List<double>> linePoints =
          findLinePoints(newCoords[0], newCoords[1], degree);

      List<List<List<double>>> splittedLists = matrixSeperator(linePoints);
      var result = calculateScan(splittedLists, bpArray);
      for (int i = 0; i < result[0].length; i++) {
        for (int j = 0; j < result[0].length; j++) {
          setState(() {});
          resulBackprojectedArray[i][j] += result[i][j];
        }
      }
    }
  }

  getSize() {
    if (MediaQuery.of(context).size.width <= 1400 &&
        MediaQuery.of(context).size.width >= 600) {
      return 70;
    } else if (MediaQuery.of(context).size.width > 1400) {
      return 100;
    } else {
      return 40;
    }
  }
}
