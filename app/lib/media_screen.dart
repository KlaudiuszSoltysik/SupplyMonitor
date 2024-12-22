import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'media_details_screen.dart';
import 'components.dart';

class MediaScreen extends StatefulWidget {
  final int factoryNumber;

  const MediaScreen({super.key, required this.factoryNumber});

  @override
  MediaScreenState createState() => MediaScreenState();
}

class MediaScreenState extends State<MediaScreen> {
  double screenWidth = 0;

  GestureDetector mediaCard(
      {required int mediumType,
      required IconData icon,
      required double safeGaugeMax,
      required double warningGaugeMax,
      required double gaugeValue}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaDetailsScreen(
              factoryNumber: widget.factoryNumber,
              mediumType: mediumType,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffcccccc),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: screenWidth / 3.5,
                  color: Colors.blue[800],
                ),
              ),
              Container(
                height: screenWidth / 3.5 + 10,
                width: screenWidth / 3.5 + 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: safeGaugeMax,
                            color: Colors.blue[800],
                          ),
                          GaugeRange(
                            startValue: safeGaugeMax,
                            endValue: warningGaugeMax,
                            color: Colors.orange[800],
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: gaugeValue,
                            needleColor: Colors.blue[800],
                            needleStartWidth: 2,
                            needleEndWidth: 2,
                            knobStyle: KnobStyle(
                              knobRadius: 0.1,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              gaugeValue.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[800],
                              ),
                            ),
                            angle: 90,
                            positionFactor: 0.5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Produkcja:',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              mediaCard(
                mediumType: 0,
                icon: Icons.solar_power,
                safeGaugeMax: 80,
                warningGaugeMax: 100,
                gaugeValue: 60,
              ),
              const SizedBox(height: 20),
              mediaCard(
                mediumType: 1,
                icon: Icons.wind_power,
                safeGaugeMax: 80,
                warningGaugeMax: 100,
                gaugeValue: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Zużycie:',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              mediaCard(
                mediumType: 2,
                icon: Icons.lightbulb,
                safeGaugeMax: 80,
                warningGaugeMax: 100,
                gaugeValue: 60,
              ),
              const SizedBox(height: 20),
              mediaCard(
                mediumType: 3,
                icon: Icons.local_fire_department,
                safeGaugeMax: 80,
                warningGaugeMax: 100,
                gaugeValue: 60,
              ),
              const SizedBox(height: 20),
              mediaCard(
                mediumType: 4,
                icon: Icons.water_drop,
                safeGaugeMax: 80,
                warningGaugeMax: 100,
                gaugeValue: 60,
              ),
              const SizedBox(height: 10),
            ],
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
