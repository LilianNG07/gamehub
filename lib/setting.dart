import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool soundEnabled = true;
  bool notificationsEnabled = true;
  String language = 'English';
  String theme = 'Classic';
  String difficulty = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Sound'),
            value: soundEnabled,
            onChanged: (bool value) {
              setState(() {
                soundEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: language,
              onChanged: (String? newValue) {
                setState(() {
                  language = newValue!;
                });
              },
              items: <String>['English', 'French', 'Spanish', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<String>(
              value: theme,
              onChanged: (String? newValue) {
                setState(() {
                  theme = newValue!;
                });
              },
              items: <String>['Classic', 'Modern', 'Fantasy', 'Sci-fi']
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