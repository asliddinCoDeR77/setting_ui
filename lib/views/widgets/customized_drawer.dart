import 'package:flutter/material.dart';
import 'package:perfect_settings_ui/views/screen/home_screen.dart';
import 'package:perfect_settings_ui/views/screen/notes_screen.dart';
import 'package:perfect_settings_ui/views/screen/settings_screen.dart';
import 'package:perfect_settings_ui/views/screen/todo_screen.dart';

class CustomizedDrawer extends StatelessWidget {
  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<Color> onColorChanged;

  const CustomizedDrawer({
    super.key,
    required this.onThemeModeChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('MENU'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) {
                    return HomeScreen(
                      onThemeModeChanged: onThemeModeChanged,
                    );
                  },
                ),
              );
            },
            leading: const Icon(Icons.home),
            title: const Text("HOME SCREEN"),
            trailing: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) {
                    return SettingsScreen(
                      onThemeModeChanged: onThemeModeChanged,
                      onColorChanged: onColorChanged,
                    );
                  },
                ),
              );
            },
            leading: const Icon(Icons.settings),
            title: const Text("SETTINGS SCREEN"),
            trailing: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) {
                    return TodoScreen();
                  },
                ),
              );
            },
            leading: const Icon(Icons.task_rounded),
            title: const Text("TODO SCREEN"),
            trailing: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) {
                    return NoteScreen();
                  },
                ),
              );
            },
            leading: const Icon(Icons.note),
            title: const Text("NOTE SCREEN"),
            trailing: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
