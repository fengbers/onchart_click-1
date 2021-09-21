import 'dart:math';
import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

String? pointValue;
String? pointValue2;

GlobalKey globalKey = GlobalKey<_CustomTextState>();
void main() {
  return runApp(MultipleAxesApp());
}

/// This widget will be the root of application.
class MultipleAxesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Range Selector Demo',
      home: MultipleAxes(),
    );
  }
}

class ChartData {
  ChartData(this.minutes, this.valueY1, this.valueY2);

  final double minutes;
  final double valueY1;
  final double valueY2;
}

class MultipleAxes extends StatefulWidget {
  const MultipleAxes({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MultipleAxes createState() => _MultipleAxes();
}

class _MultipleAxes extends State<MultipleAxes> {
  ChartSeriesController? seriesController, seriesController1;
  Offset annotationPosition1 = Offset(0, 0);
  ChartData? hitPoint;
  MaterialColor? color;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Axes',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
            softWrap: true,
            textScaleFactor: 1,
            overflow: TextOverflow.fade),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
              child: Column(
            children: [
              SfCartesianChart(
                annotations: <CartesianChartAnnotation>[
                  CartesianChartAnnotation(
                    widget: Container(
                      width: 60,
                      height: 55,
                      color: color,
                      child: Column(
                        children: [
                          Center(
                              child: Text("x: " +
                                  (hitPoint?.minutes.toStringAsFixed(1) ??
                                      ""))),
                          Center(
                              child: Text("Y1: " +
                                  (hitPoint?.valueY1.toStringAsFixed(1) ??
                                      ""))),
                          Center(
                              child: Text("Y2: " +
                                  (hitPoint?.valueY2.toStringAsFixed(1) ??
                                      ""))),
                        ],
                      ),
                    ),
                    coordinateUnit: CoordinateUnit.logicalPixel,
                    region: AnnotationRegion.chart,
                    x: annotationPosition1.dx, // x position of annotation
                    y: annotationPosition1.dy, // y position of annotation
                  ),
                ],
                axes: [
                  NumericAxis(
                    name: 'secondaryYAxis',
                    opposedPosition: true,
                    title: AxisTitle(text: 'Y2'),
                    maximum: 40,
                  ),
                ],
                zoomPanBehavior:
                    ZoomPanBehavior(enablePinching: true, enablePanning: true),
                onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
                  color = Colors.red;
                  annotationPosition1 = args.position;
                  CartesianChartPoint? dataPoint =
                      seriesController?.pixelToPoint(args.position);

                  pointValue = 'x value = ' +
                      (dataPoint!.x.toInt()).toString() +
                      '\n' +
                      'y1 value = ' +
                      dataPoint.y.toStringAsFixed(1);

                  CartesianChartPoint? dataPoint1 =
                      seriesController1?.pixelToPoint(annotationPosition1);

                  pointValue2 = 'x value = ' +
                      (dataPoint1!.x.toInt()).toString() +
                      '\n' +
                      'y2 value = ' +
                      dataPoint1.y.toStringAsFixed(1);
                  hitPoint = ChartData(dataPoint.x, dataPoint.y, dataPoint1.y);
                  setState(() {});
                  globalKey.currentState!.setState(() {});
                },
                onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
                  color = Colors.blue;
                  setState(() {});
                  globalKey.currentState!.setState(() {});
                },
                title: ChartTitle(
                    text: 'Sample',
                    alignment: ChartAlignment.center,
                    borderColor: Colors.white,
                    borderWidth: 0),
                primaryXAxis: NumericAxis(
                    title: AxisTitle(text: 'Minutes'), maximum: 100),
                primaryYAxis: NumericAxis(
                    plotOffset: 0,
                    title: AxisTitle(
                        text: 'Y1',
                        textStyle: const TextStyle(color: Colors.black))),
                series: <LineSeries<ChartData, double>>[
                  LineSeries<ChartData, double>(
                    markerSettings: MarkerSettings(isVisible: true),
                    onRendererCreated: (ChartSeriesController controller) {
                      seriesController = controller;
                    },
                    dataSource: getData(),
                    xAxisName: "", //compulsary to take primary xaxis
                    yAxisName: "", //compulsary to take primary yaxis
                    xValueMapper: (ChartData conc, _) => conc.minutes,
                    yValueMapper: (ChartData conc, _) => conc.valueY1,
                  ),
                  LineSeries<ChartData, double>(
                    onRendererCreated: (ChartSeriesController controller) {
                      seriesController1 = controller;
                    },
                    markerSettings: MarkerSettings(isVisible: true),
                    dataSource: getData(),
                    xAxisName: "", //compulsary to take primary xaxis

                    yAxisName: 'secondaryYAxis',
                    xValueMapper: (ChartData conc, _) => conc.minutes,
                    yValueMapper: (ChartData conc, _) => conc.valueY2,
                  ),
                ],
              ),
              CustomText(key: globalKey),
            ],
          ));
        },
      ),
    );
  }

  static List<ChartData> getData() {
    final dynamic chartData = <ChartData>[
      ChartData(0, 0, 0),
      ChartData(10, 28, 20),
      ChartData(20, 24, 18),
      ChartData(30, 35, 7),
      ChartData(40, 38, 40),
      ChartData(50, 54, 25),
      ChartData(60, 21, 55),
      ChartData(70, 24, 45),
      ChartData(80, 35, 21),
      ChartData(90, 38, 27),
      ChartData(100, 54, 42),
      ChartData(110, 38, 17),
      ChartData(120, 54, 34)
    ];
    return chartData;
  }
}

int getRandomInt(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

// Sample ordinal data type.

class CustomText extends StatefulWidget {
  CustomText({Key? key}) : super(key: key);

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(child: Text(pointValue ?? 'Click on chart')),
            Center(child: Text(pointValue2 ?? ''))
          ],
        ));
  }
}
