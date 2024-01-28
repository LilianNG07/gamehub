import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String theme = 'default';
  String difficulty = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<String>(
              value: theme,
              onChanged: (String? newValue) {
                setState(() {
                  theme = newValue!;
                });
              },
              items: <String>['Default', 'Classic']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Difficulty'),
            trailing: DropdownButton<String>(
              value: difficulty,
              onChanged: (String? newValue) {
                setState(() {
                  difficulty = newValue!;
                });
              },
              items: <String>['Easy', 'Medium', 'Hard', 'Expert']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
