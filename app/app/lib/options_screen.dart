import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import 'main.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  OptionsScreenState createState() => OptionsScreenState();
}

class OptionsScreenState extends State<OptionsScreen> {
  final String email = 'klaudiusz.soltysik@vw-poznan.pl';
  final String phoneNumber = '+48 734 451 590';

  void closeAndEmail() async {
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: appState.darkMode,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white30,
                      inactiveTrackColor: Colors.white30,
                      inactiveThumbColor: Colors.blue[800],
                      onChanged: (value) {
                        setState(() {
                          appState.toggleDarkMode();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Tryb ciemny',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Administrator aplikacji:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text:
                            'Klaudiusz Sołtysik\nPW-1 Energy Management\nEmail: ',
                      ),
                      TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                        text: email,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Clipboard.setData(ClipboardData(text: email));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Skopiowano do schowka: $email'),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text: '\nTel: ',
                      ),
                      TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                        text: phoneNumber,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Clipboard.setData(ClipboardData(text: phoneNumber));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Skopiowano do schowka: $phoneNumber'),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Zgłaszanie błędów lub problemów z aplikacją:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text:
                            'W przypadku napotkania błędów lub problemów z działaniem aplikacji, proszę o kontakt pod adresem e-mail: ',
                      ),
                      TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                        text: email,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Clipboard.setData(ClipboardData(text: email));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Skopiowano do schowka: $email'),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Prośby o dostęp:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text:
                            'Jeśli potrzebujesz dostępu do aplikacji, proszę o kontakt na adres e-mail: ',
                      ),
                      TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                        text: email,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Clipboard.setData(ClipboardData(text: email));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Skopiowano do schowka: $email'),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        text: ', podając szczegóły dotyczące żądania.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      closeAndEmail();
                    },
                    child: const Text(
                      'Email',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
