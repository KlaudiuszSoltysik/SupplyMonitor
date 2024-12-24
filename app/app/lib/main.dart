import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'main_page.dart';

// TODO: Fix mailing
// TODO: Auth
// TODO: API calls
// TODO: Max and min supply value

class AppState extends ChangeNotifier {
  AppState() {
    loadSharedPreferences();
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    saveSharedPreferences();
    notifyListeners();
  }

  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void loadSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _darkMode =
        prefs.getBool('darkMode') ?? prefs.getBool('firstLaunch') ?? true;

    notifyListeners();
  }

  void saveSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkMode);
    prefs.setBool('firstLaunch', false);
  }
}

Future<void> main() async {
  await dotenv.load();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          home: const MainPage(),
          theme: ThemeData.light().copyWith(
            textTheme: const TextTheme().copyWith(
              bodyMedium: TextStyle(color: Colors.blue[800]),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue[800],
              unselectedItemColor: Colors.blue[200],
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xff333333),
            textTheme: const TextTheme().copyWith(
              bodyMedium: const TextStyle(color: Colors.white),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white30,
              backgroundColor: Color(0xff121212),
            ),
          ),
          themeMode: appState.darkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
