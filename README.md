# CT Scan Application

This program is designed to test and simulate computerized tomography (CT) imaging. It allows the generation of new images based on user-defined parameters such as the number of X-ray rays, the range of rotation angles, and the rotation speed.

## Features

- **X-ray Ray Generation:** The program generates X-ray rays based on user input.

- **Rotation Angle Range:** Users can specify the range of rotation angles for image reconstruction.

- **Rotation Speed Control:** The rotation speed parameter influences the speed at which the reconstruction process takes place.

- **Image Reconstruction:** The application utilizes the provided parameters to reconstruct new images through a simulated CT process.

## Usage

To run the program, provide the following inputs:

1. **Number of X-ray rays.**
2. **Range of rotation angles.**
3. **Rotation speed.**

After running the program, it will simulate the CT process and generate new images based on the specified parameters.

## How to Use

1. **Enter the number of X-ray rays.**
2. **Specify the range of rotation angles.**
3. **Set the rotation speed.**
4. **Run the program to generate new images.**

Enjoy exploring the capabilities of this CT image reconstruction application!


## What is CT (Computed Tomography)?

Computed Tomography (CT) is a medical imaging technique that can create detailed cross-sectional images within the body. CT scans provide a three-dimensional perspective by combining images taken from different angles. This allows for a more precise examination of internal organs and tissues.

![Screenshot_5](https://github.com/euphranos/ct_simulation_app/assets/109268253/4d53918c-317f-4ef6-a20e-9ad124c768a2)

## Screenshots from app
![Screenshot_1](https://github.com/euphranos/ct_simulation_app/assets/109268253/3c52b192-8663-4d31-a424-599509b9059e)
![Screenshot_2](https://github.com/euphranos/ct_simulation_app/assets/109268253/1ab97b03-5764-48c0-9b94-5a43271d256a)

## The value table represents the density, and thus the density of the matrix. It is color-coded and numbered based on density

![Screenshot_3](https://github.com/euphranos/ct_simulation_app/assets/109268253/06f21ba0-e55b-426c-b6dd-48001f7c5aba)
## The image represents a structure of a CT (computed tomography) composed of X-rays and a detector. It simulates the tomography process based on user-input values such as rotation speed, range of rotation angles, and other factors
The value table represents the density, and thus the density of the matrix. It is color-coded and numbered based on density
![Screenshot_4](https://github.com/euphranos/ct_simulation_app/assets/109268253/84c74bef-4807-4a0c-b955-d9fd30461a3d)



## How it works ? 
![1](https://github.com/euphranos/ct_simulation_app/assets/109268253/577f3055-8572-48d7-8ca3-31544f0b8cdc)
![2](https://github.com/euphranos/ct_simulation_app/assets/109268253/dd28858f-b19b-424a-9987-3284032e20c5)
![3](https://github.com/euphranos/ct_simulation_app/assets/109268253/9db33b14-b3ab-42a5-92a1-b82fdb8ab36c)
![5](https://github.com/euphranos/ct_simulation_app/assets/109268253/7d49ca45-fdd4-4e19-8411-d2c0442a1d62)



For a given ray, the equation of the line is first derived. With the help of the angle obtained by rotating the line, the new equation of the line is calculated. Every point on the new line equation is identified. The matrices through which these points pass are determined, and before being written to the new matrix, they are divided by the length of the line. This process is repeated for each angle. This entire process is then repeated for each ray. Each resulting new matrix is divided by the value of (number of rays * number of rotation iterations) and backprojected



## Generating X-ray beams and determining their coordinates

Generate X-rays equivalent to the input value of the number of rays provided by the user.

```dart
List<List<double>> generateBeams(int sample) {
  double samplingIncreaseCount = 4 / sample;

  List<List<double>> allBeams = [];

  for (double i = -2; i <= 2; i += samplingIncreaseCount) {
    allBeams.add([-2, i]);
  }
  return allBeams;
}

```

## Scanning for all X-Ray Beams

```dart
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
```

## Calculating new line coordinates

```dart
var newCoords = calculateNewCoordinate(degree, element[0], element[1]);
```

```dart
List<double> calculateNewCoordinate(double degree, double x, double y) {
  double newDegree = degree * pi / 180;

  double newX = x * cos(newDegree) - y * sin(newDegree);
  double newY = x * sin(newDegree) + y * cos(newDegree);

  return [newX, newY];
}
```


## Calculating each point of line


```dart
      List<List<double>> linePoints =
          findLinePoints(newCoords[0], newCoords[1], degree);

}
```

```dart
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
}
```

## Seperating line for each matrices

Calculates which lines the matrix passes through


 ```dart
List<List<List<double>>> splittedLists = matrixSeperator(linePoints);
````

## Calculating Scan

The value of each matrix through which the ray passes is divided by the length of the ray and added to the new matrix. The process is repeated for each ray.

## Scanning for all beams for one degree

Performs the scanning process for all rays at the given degree parameter

```dart
scanForAllBeamsForOneDegree(i);
```

## Scanning for each degrees

Enables scanning process from 0 to 179 degrees, incrementing by the user-input value

```dart
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
```

  




## Requirements

- Flutter: [Flutter Download Page](https://flutter.dev/docs/get-started/install)

## Installation

1. Download and install Flutter on your computer.
2. Clone the project to your computer or extract the ZIP file.
3. Open the terminal or command prompt and navigate to the project directory.
4. Run the following command to install dependencies:


Usage
Upon starting the application, it processes images scanned from different angles and performs a CT scan. The user interface allows users to view the obtained images and save them if necessary.

Applications of CT

Diagnosis: CT scans are commonly used for diagnosing various diseases.
Surgical Planning: Surgeons may use CT scans to plan their operations more precisely.
Trauma Cases: In emergency situations, especially traumatic injuries, CT scans are used to detect internal organ damage.
Cancer Monitoring: CT scans are employed to monitor the growth or shrinkage of tumors during the treatment of cancer.

```bash
flutter pub get


Start the application with the following command:
flutter run

