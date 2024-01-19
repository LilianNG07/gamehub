import 'package:flutter/material.dart';
import 'package:gamehub/resume.dart';
import 'package:gamehub/setting.dart';
import 'chess_game.dart'; // Assurez-vous que ce fichier existe et contient le widget ChessBoardPage

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Utilisation de Wrap pour les images des reines
            Wrap(
              spacing: 8.0, // Espace horizontal entre les enfants
              alignment: WrapAlignment.center,
              children: <Widget>[
                Image.asset('assets/img/theme_defaut/black/queen.png', width: 100, height: 100),
                Image.asset('assets/img/theme_defaut/white/queen.png', width: 100, height: 100),
              ],
            ),
            SizedBox(height: 20),
            // Row pour le bouton 'New Game'
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChessBoardPage()),
                        );
                      },
                      child: Text('New Game'),
                    ),
                  ),
                ),
              ],
            ),
            // Row pour le bouton 'Resume Game'
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResumePage()),
                        );
                      },
                      child: Text('Resume Game'),
                    ),
                  ),
                ),
              ],
            ),
            // Row pour le bouton 'Settings'
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                      },
                      child: Text('Settings'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

