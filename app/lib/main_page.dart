import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'options_screen.dart';
import 'weather_screen.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  final int lastFactory;

  const MainPage({super.key, this.lastFactory = -1});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final int selectedIndex = appState.selectedIndex;

    return Scaffold(
      body: selectedIndex == 0
          ? WeatherScreen(lastFactory: widget.lastFactory)
          : selectedIndex == 1
              ? const HomeScreen()
              : const OptionsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Pogoda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Strona Główna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Opcje',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          Provider.of<AppState>(
            context,
            listen: false,
          ).updateSelectedIndex(index);
        },
      ),
    );
  }
}
