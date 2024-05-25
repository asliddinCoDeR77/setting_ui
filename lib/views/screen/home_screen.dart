import 'package:flutter/material.dart';
import 'package:perfect_settings_ui/views/widgets/applocalizitions.dart';
import 'package:perfect_settings_ui/views/widgets/customized_drawer.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  const HomeScreen({
    super.key,
    required this.onThemeModeChanged,
    required this.onLocaleChanged,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _appBarColor = Colors.blue;
  String _selectedLanguage = 'en';

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('pick_color')),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _appBarColor,
              onColorChanged: (color) {
                setState(() {
                  _appBarColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('done')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onColorChanged(Color color) {
    setState(() {
      _appBarColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('home_screen_title')),
        backgroundColor: _appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPickerDialog,
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            icon: const Icon(Icons.language),
            items: <String>['en', 'ru', 'uz']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'en'
                      ? 'English'
                      : value == 'ru'
                          ? 'Russian'
                          : 'Uzbek',
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
                widget.onLocaleChanged(Locale(newValue));
              });
            },
          ),
        ],
      ),
      drawer: CustomizedDrawer(
        onThemeModeChanged: widget.onThemeModeChanged,
        onColorChanged: _onColorChanged,
      ),
      body: Center(
        child:
            Text(AppLocalizations.of(context).translate('home_screen_content')),
      ),
    );
  }
}
