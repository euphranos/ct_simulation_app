import 'dart:math';

List<double> calculateNewCoordinate(double degree, double x, double y) {
  double newDegree = degree * pi / 180;

  double newX = x * cos(newDegree) - y * sin(newDegree);
  double newY = x * sin(newDegree) + y * cos(newDegree);

  return [newX, newY];
}

//

//doğru denklemini bulma fonksiyonu yaz
List<List<double>> findLinePoints(double x, double y, double degree) {
  double newDegree = degree * pi / 180;
  double n = y - tan(newDegree) * x;

  List<List<double>> linePoints = [];

  for (double i = -2; i <= 2; i += 0.01) {
    double pointY = tan(newDegree) * i + n;

    if (pointY >= -2 && pointY <= 2) {
      linePoints.add([i, pointY]);
    }
  }

  return linePoints;
}

//doğru uzunluğu bulma

double calculateLengthOfLine(double x1, double x2, double y1, double y2) {
  double lineLength = sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));
  return lineLength;
}

//matrisi koordinat düzlemine yerleştirmek için numaralandır (matris encode)

List<List<List<double>>> matrixSeperator(List<List<double>> matrix) {
  List<List<List<double>>> splittedLists = List.generate(16, (index) => []);

  for (var element in matrix) {
    double x = element[0];
    double y = element[1];
    //0.matris
    if (x >= -2 && x <= -1 && y >= 1 && y <= 2) {
      //burada listelere ekle
      splittedLists[0].add([x, y]);
    }
    //1.matris
    if (x >= -1 && x <= 0 && y >= 1 && y <= 2) {
      //burada listelere ekle
      splittedLists[1].add([x, y]);
    }
    //2.matris
    if (x >= 0 && x <= 1 && y >= 1 && y <= 2) {
      //burada listelere ekle
      splittedLists[2].add([x, y]);
    }

    //3.matris
    if (x >= 1 && x <= 2 && y >= 1 && y <= 2) {
      //burada listelere ekle
      splittedLists[3].add([x, y]);
    }
    //******************************************************* *///
    //4.matris
    if (x >= -2 && x <= -1 && y >= 0 && y <= 1) {
      //burada listelere ekle
      splittedLists[4].add([x, y]);
    }

    //5.matris
    if (x >= -1 && x <= 0 && y >= 0 && y <= 1) {
      //burada listelere ekle
      splittedLists[5].add([x, y]);
    }
    //6.matris
    if (x >= 0 && x <= 1 && y >= 0 && y <= 1) {
      //burada listelere ekle
      splittedLists[6].add([x, y]);
    }
    //7.matris
    if (x >= 1 && x <= 2 && y >= 0 && y <= 1) {
      //burada listelere ekle
      splittedLists[7].add([x, y]);
    }
    //******************************************************* *///

    //8.matris

    if (x >= -2 && x <= -1 && y >= -1 && y <= 0) {
      //burada listelere ekle
      splittedLists[8].add([x, y]);
    }

    //9.matris
    if (x >= -1 && x <= 0 && y >= -1 && y <= 0) {
      //burada listelere ekle
      splittedLists[9].add([x, y]);
    }
    //10.matris

    if (x >= 0 && x <= 1 && y >= -1 && y <= 0) {
      //burada listelere ekle
      splittedLists[10].add([x, y]);
    }

    //11.matris
    if (x >= 1 && x <= 2 && y >= -1 && y <= 0) {
      //burada listelere ekle
      splittedLists[11].add([x, y]);
    }
    //******************************************************* *///
    //12.Matris
    if (x >= -2 && x <= -1 && y >= -2 && y <= -1) {
      //burada listelere ekle
      splittedLists[12].add([x, y]);
    }

    //13.matris
    if (x >= -1 && x <= 0 && y >= -2 && y <= -1) {
      //burada listelere ekle
      splittedLists[13].add([x, y]);
    }
    //14.matris

    if (x >= 0 && x <= 1 && y >= -2 && y <= -1) {
      //burada listelere ekle
      splittedLists[14].add([x, y]);
    }

    //15.matris
    if (x >= 1 && x <= 2 && y >= -2 && y <= -1) {
      //burada listelere ekle
      splittedLists[15].add([x, y]);
    }

    //son
  }

  return splittedLists;
}

//matrisi scan edip tarama

List<List<double>> calculateScan(
    List<List<List<double>>> splittedLists, List<List<double>> rawImageMatrix) {
  List<List<double>> backProjectedList = List.generate(
    rawImageMatrix.length,
    (index) => List<double>.filled(rawImageMatrix[index].length, 0),
  );
  for (int i = 0; i < 16; i++) {
    if (splittedLists[i].isNotEmpty) {
      List<double> minPoints = findIntersectionPoints(splittedLists[i])[0];
      List<double> maxPoints = findIntersectionPoints(splittedLists[i])[1];
      double length = calculateLengthOfLine(
          minPoints[0], maxPoints[0], minPoints[1], maxPoints[1]);

      if (length == 0) {
        length = 1;
      }

      if (i == 0) {
        double value = rawImageMatrix[0][0] / length;
        backProjectedList[0][0] = value;
      } else if (i == 1) {
        double value = rawImageMatrix[0][1] / length;
        backProjectedList[0][1] = value;
      } else if (i == 2) {
        double value = rawImageMatrix[0][2] / length;
        backProjectedList[0][2] = value;
      } else if (i == 3) {
        double value = rawImageMatrix[0][3] / length;
        backProjectedList[0][3] = value;
      } else if (i == 4) {
        double value = rawImageMatrix[1][0] / length;
        backProjectedList[1][0] = value;
      } else if (i == 5) {
        double value = rawImageMatrix[1][1] / length;
        backProjectedList[1][1] = value;
      } else if (i == 6) {
        double value = rawImageMatrix[1][2] / length;
        backProjectedList[1][2] = value;
      } else if (i == 7) {
        double value = rawImageMatrix[1][3] / length;
        backProjectedList[1][3] = value;
      } else if (i == 8) {
        double value = rawImageMatrix[2][0] / length;
        backProjectedList[2][0] = value;
      } else if (i == 9) {
        double value = rawImageMatrix[2][1] / length;
        backProjectedList[2][1] = value;
      } else if (i == 10) {
        double value = rawImageMatrix[2][2] / length;
        backProjectedList[2][2] = value;
      } else if (i == 11) {
        double value = rawImageMatrix[2][3] / length;
        backProjectedList[2][3] = value;
      } else if (i == 12) {
        double value = rawImageMatrix[3][0] / length;
        backProjectedList[3][0] = value;
      } else if (i == 13) {
        double value = rawImageMatrix[3][1] / length;
        backProjectedList[3][1] = value;
      } else if (i == 14) {
        double value = rawImageMatrix[3][2] / length;
        backProjectedList[3][2] = value;
      } else if (i == 15) {
        double value = rawImageMatrix[3][3] / length;
        backProjectedList[3][3] = value;
      } else {}

      //bu değeri backprojection matrisine ekle
    }
  }
  //backProjectionList return et
  return backProjectedList;
}

// matristeki doğrunun ilk kesiştiği ve son kesiştiği noktayı bulma
// burayı yarın yaz . yazdıktan sonra generatebeams fonksiyonunu yaz . log at hatayı bul

List<List<double>> findIntersectionPoints(List<List<double>> targetList) {
  List<double> minPoints = targetList[0];
  List<double> maxPoints = targetList[0];

  for (var element in targetList) {
    if (element[0] <= minPoints[0]) {
      minPoints = element;
    }
    if (element[0] >= maxPoints[0]) {
      maxPoints = element;
    }
  }

  return [minPoints, maxPoints];
}

List<List<double>> generateBeams(int sample) {
  double samplingIncreaseCount = 4 / sample;

  List<List<double>> allBeams = [];

  for (double i = -2; i <= 2; i += samplingIncreaseCount) {
    allBeams.add([-2, i]);
  }
  return allBeams;
}



// void main() {
//   int x0=-2;
//   int y0=0;
//   double degree=45;
  
//   var newCoords=calculateNewCoordinate(45,x0,y0);
//   print(findLinePoints(newCoords[0],newCoords[1],45));
 
// }