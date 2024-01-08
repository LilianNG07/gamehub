import 'package:flutter/material.dart';

class ResumePage extends StatefulWidget {
  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  List<Map<String, dynamic>> savedGames = [
    {
      'date': '2024-01-08 14:00',
      'opponent': 'AI',
      'difficulty': 'Medium',
    },
    // Ajoutez plus d'entrées ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Game'),
      ),
      body: ListView.builder(
        itemCount: savedGames.length,
        itemBuilder: (context, index) {
          var game = savedGames[index];
          return ListTile(
            title: Text('Game against ${game['opponent']}'),
            subtitle: Text('Saved on ${game['date']}'),
            trailing: Text('Difficulty: ${game['difficulty']}'),
            onTap: () {
              // Ajouter la logique pour reprendre la partie sélectionnée
            },
          );
        },
      ),
    );
  }
}
