import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'main_page.dart';

BottomNavigationBar bottomNavigationBar(
    BuildContext context, int factoryNumber) {
  return BottomNavigationBar(
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
    currentIndex: 0,
    selectedItemColor: Provider.of<AppState>(context).darkMode
        ? Colors.white30
        : Colors.blue[200],
    onTap: (index) {
      Provider.of<AppState>(
        context,
        listen: false,
      ).updateSelectedIndex(index);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(lastFactory: factoryNumber),
        ),
      );
    },
  );
}
