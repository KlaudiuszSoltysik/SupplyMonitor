import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'components.dart';

class MediaDetailsScreen extends StatefulWidget {
  final int factoryNumber;
  final int mediumType;

  const MediaDetailsScreen(
      {Key? key, required this.factoryNumber, required this.mediumType})
      : super(key: key);

  @override
  MediaDetailsScreenState createState() => MediaDetailsScreenState();
}

class MediaDetailsScreenState extends State<MediaDetailsScreen> {
  int activeButton = 0;
  double screenWidth = 0;

  LineChartBarData createLineBarsData() {
    List<FlSpot> spots = [];
    final Random random = Random();

    if (activeButton == 0) {
      for (int i = 0; i < 24; i++) {
        spots.add(
          FlSpot(
            i.toDouble(),
            random.nextDouble(),
          ),
        );
      }
    } else if (activeButton == 1) {
      for (int i = 0; i < 28; i++) {
        spots.add(
          FlSpot(
            i.toDouble(),
            random.nextDouble(),
          ),
        );
      }
    } else if (activeButton == 2) {
      for (int i = 0; i < 30; i++) {
        spots.add(
          FlSpot(
            i.toDouble(),
            random.nextDouble(),
          ),
        );
      }
    } else if (activeButton == 3) {
      for (int i = 0; i < 365; i++) {
        spots.add(
          FlSpot(
            i.toDouble(),
            random.nextDouble(),
          ),
        );
      }
    }

    return LineChartBarData(
      isCurved: false,
      color: Colors.blue[800],
      barWidth: 4,
      spots: spots,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: false),
    );
  }

  ElevatedButton durationButton(
      {required int buttonNumber, required String text}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            activeButton == buttonNumber ? Colors.blue[800] : Colors.blue[200],
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        setState(() {
          activeButton = buttonNumber;
          createLineBarsData();
        });
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Text title() {
    String text = '';

    if (widget.mediumType == 0) {
      text =
          'Zakład ${widget.factoryNumber}\nProdukcja z paneli fotowoltaicznych';
    } else if (widget.mediumType == 1) {
      text = 'Zakład ${widget.factoryNumber}\nProdukcja z turbin wiatrowych';
    } else if (widget.mediumType == 2) {
      text = 'Zakład ${widget.factoryNumber}\nZużycie energii elektrycznej';
    } else if (widget.mediumType == 3) {
      text = 'Zakład ${widget.factoryNumber}\nZużycie gazu';
    } else if (widget.mediumType == 4) {
      text = 'Zakład ${widget.factoryNumber}\nZużycie wody';
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: title(),
                ),
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      showLastLabel: true,
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: 80,
                          color: Colors.blue[800],
                        ),
                        GaugeRange(
                          startValue: 80,
                          endValue: 100,
                          color: Colors.orange[800],
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: 69,
                          needleColor: Colors.blue[800],
                          needleStartWidth: 2,
                          needleEndWidth: 5,
                          knobStyle: KnobStyle(
                            knobRadius: 0.07,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                      annotations: const <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.5,
                          widget: Text(
                            '69',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Text(
                  'Ostatni:',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    durationButton(
                      buttonNumber: 0,
                      text: 'dzień',
                    ),
                    durationButton(
                      buttonNumber: 1,
                      text: 'tydzień',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    durationButton(
                      buttonNumber: 2,
                      text: 'miesiąc',
                    ),
                    durationButton(
                      buttonNumber: 3,
                      text: 'rok',
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: screenWidth / 2,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: const LineTouchData(enabled: false),
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [createLineBarsData()],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        context,
        widget.factoryNumber,
      ),
    );
  }
}
