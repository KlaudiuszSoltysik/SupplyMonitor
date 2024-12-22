import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class WeatherScreen extends StatefulWidget {
  final int lastFactory;

  const WeatherScreen({Key? key, this.lastFactory = 0}) : super(key: key);

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  int? activeButton;
  Future<Map<String, dynamic>>? weatherData;
  Timer? timer;
  DateTime now = DateTime.now();
  double screenWidth = 0;

  ElevatedButton forecastButton(
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
        activeButton = buttonNumber;
        loadWeatherData();
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Column forecastContainer(Map<String, dynamic>? data) {
    final String todaysDate = data!['forecast']['list'][0]['dt_txt'];

    final Match? dayMonthMatch =
        RegExp(r'-(\d{2})-(\d{2})').firstMatch(todaysDate);
    final String dayMonth =
        '${dayMonthMatch!.group(2)}-${dayMonthMatch.group(1)}';

    final Match? timeMatch = RegExp(r' (\d{2}):').firstMatch(todaysDate);
    final int hour = int.parse(timeMatch!.group(1).toString());

    int counter = 0;
    int tommorowsIndex = 0;

    List<Map<String, dynamic>> todaysForecast = [];

    for (int i = 0; i < 8; i++) {
      final String nextDate = data['forecast']['list'][i]['dt_txt'];

      final Match? nextDayMonthMatch =
          RegExp(r'-(\d{2})-(\d{2})').firstMatch(nextDate);
      final String nextDayMonth =
          '${nextDayMonthMatch!.group(2)}-${nextDayMonthMatch.group(1)}';

      final Match? nextTimeMatch =
          RegExp(r' (\d{2}):(\d{2})').firstMatch(nextDate);
      final int nextHour = int.parse(nextTimeMatch!.group(1).toString());

      if (dayMonth == nextDayMonth && hour <= nextHour) {
        counter++;

        todaysForecast.add({
          'time': data['forecast']['list'][i]['dt_txt'],
          'temp': data['forecast']['list'][i]['main']['temp'],
          'cloudiness': data['forecast']['list'][i]['clouds']['all'],
          'wind_speed': data['forecast']['list'][i]['wind']['speed'],
          'icon': data['forecast']['list'][i]['weather'][0]['icon'],
        });
      } else if (dayMonth != nextDayMonth) {
        tommorowsIndex = i;
        break;
      }
    }

    return Column(
      children: [
        counter > 0
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xffcccccc),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: screenWidth / 3,
                          width: screenWidth / 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              dayMonth,
                              style: TextStyle(
                                fontSize: screenWidth / 10,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenWidth / 3,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: counter,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      height: screenWidth / 3,
                                      width: screenWidth / 3,
                                      imageUrl:
                                          'http://openweathermap.org/img/wn/${todaysForecast[i]['icon']}@2x.png',
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) {
                                        return Center(
                                          child: SizedBox(
                                            height: screenWidth / 5,
                                            width: screenWidth / 5,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    Text(
                                      '${RegExp(r' (\d{2})').firstMatch(todaysForecast[i]['time'])!.group(1)}:00\n${todaysForecast[i]['temp'].toStringAsFixed(1)} °C\n${todaysForecast[i]['cloudiness']}%\n${todaysForecast[i]['wind_speed'].toStringAsFixed(1)} kmph',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 4
                                          ..color = Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${RegExp(r' (\d{2})').firstMatch(todaysForecast[i]['time'])!.group(1)}:00\n${todaysForecast[i]['temp'].toStringAsFixed(1)} °C\n${todaysForecast[i]['cloudiness']}%\n${todaysForecast[i]['wind_speed'].toStringAsFixed(1)} kmph',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: screenWidth / 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffcccccc),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: screenWidth / 3,
                            width: screenWidth / 3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '${RegExp(r'-(\d{2})-(\d{2})').firstMatch(data['forecast']['list'][tommorowsIndex + i * 8]['dt_txt'])!.group(2)}-${RegExp(r'-(\d{2})-(\d{2})').firstMatch(data['forecast']['list'][tommorowsIndex + i * 8]['dt_txt'])!.group(1)}',
                                style: TextStyle(
                                  fontSize: screenWidth / 10,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenWidth / 3,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, j) {
                                final forecastData = data['forecast']['list']
                                    [tommorowsIndex + i * 8 + j];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          height: screenWidth / 3,
                                          width: screenWidth / 3,
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${forecastData['weather'][0]['icon']}@2x.png',
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return Center(
                                              child: SizedBox(
                                                height: screenWidth / 5,
                                                width: screenWidth / 5,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  color: Colors.blue[800],
                                                ),
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Text(
                                          '${RegExp(r' (\d{2})').firstMatch(forecastData['dt_txt'])!.group(1)}:00\n${forecastData['main']['temp'].toStringAsFixed(1)} °C\n${forecastData['clouds']['all']}%\n${forecastData['wind']['speed'].toStringAsFixed(1)} kmph',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: screenWidth / 20,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 4
                                              ..color = Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${RegExp(r' (\d{2})').firstMatch(forecastData['dt_txt'])!.group(1)}:00\n${forecastData['main']['temp'].toStringAsFixed(1)} °C\n${forecastData['clouds']['all']}%\n${forecastData['wind']['speed'].toStringAsFixed(1)} kmph',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontSize: screenWidth / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> loadWeatherData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jsonData = prefs.getString('weather_factory$activeButton');
    if (jsonData != null) {
      setState(() {
        weatherData = Future.value(json.decode(jsonData));
      });
    }

    final Map<String, dynamic> freshData = await getWeatherData();

    setState(() {
      weatherData = Future.value(freshData);
    });

    prefs.setString('weather_factory$activeButton', json.encode(freshData));
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    final String? apiKey = dotenv.env['API_KEY'];

    double lat = 0;
    double lon = 0;

    Map<String, dynamic> weatherData = {};
    Map<String, dynamic> forecastData = {};

    if (activeButton == 0) {
      lat = 52.4119921802926;
      lon = 17.029640488794385;
    } else if (activeButton == 1) {
      lat = 52.29809870368471;
      lon = 17.51718564090986;
    } else if (activeButton == 2) {
      lat = 52.378225963404475;
      lon = 16.90778212557254;
    } else {
      lat = 52.39628030620998;
      lon = 17.104588967902355;
    }

    String weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    String forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    final weatherResponse = await http.get(Uri.parse(weatherUrl));

    if (weatherResponse.statusCode == 200) {
      weatherData = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load weather data.');
    }

    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (forecastResponse.statusCode == 200) {
      forecastData = jsonDecode(forecastResponse.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load forecast data.');
    }

    return {'weather': weatherData, 'forecast': forecastData};
  }

  @override
  void initState() {
    super.initState();
    widget.lastFactory < 0
        ? activeButton = 0
        : activeButton = widget.lastFactory - 1;
    loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Provider.of<AppState>(context).darkMode;
    const List<String> days = ['Pn', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Ndz'];

    now = DateTime.now();
    screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: () async {
        await loadWeatherData();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffcccccc),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${days[now.weekday - 1]} ${DateFormat('dd-MM').format(now)}\n${DateFormat('HH:mm').format(now)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffcccccc),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int j = 0; j < 2; j++)
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: forecastButton(
                                buttonNumber: i * 2 + j,
                                text: 'Zakład ${i * 2 + j + 1}',
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: weatherData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && weatherData != null) {
                    timer?.cancel();

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xffcccccc),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CachedNetworkImage(
                                    height: screenWidth / 3,
                                    width: screenWidth / 3,
                                    imageUrl:
                                        'http://openweathermap.org/img/wn/${snapshot.data!['weather']['weather'][0]['icon']}@2x.png',
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return Center(
                                        child: SizedBox(
                                          height: screenWidth / 5,
                                          width: screenWidth / 5,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  // Image(
                                  //   image: NetworkImage(
                                  //       'http://openweathermap.org/img/wn/${snapshot.data!['weather']['weather'][0]['icon']}@2x.png'),
                                  // ),
                                  Text(
                                    '${snapshot.data!['weather']['main']['temp'].toStringAsFixed(1)} °C',
                                    style: TextStyle(
                                      fontSize: 45,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Zachmurzenie: ${snapshot.data!['weather']['clouds']['all']}%',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Text(
                                'N',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Transform.rotate(
                                angle: snapshot.data!['weather']['wind']
                                        ['deg'] *
                                    3.14 /
                                    180,
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: screenWidth / 3,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Text(
                                '${snapshot.data!['weather']['wind']['speed'].toStringAsFixed(1)} kmph',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        forecastContainer(snapshot.data),
                      ],
                    );
                  } else if (snapshot.hasError && weatherData == null) {
                    timer?.cancel();
                    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                      loadWeatherData();
                    });
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        width: screenWidth / 2,
                        height: screenWidth / 2,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          color: darkMode ? Colors.white : Colors.blue[800],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
