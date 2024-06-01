import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:perfect_settings_ui/views/widgets/customized_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeModeChanged;

  const HomeScreen({
    super.key,
    required this.onThemeModeChanged,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _appBarColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadAppBarColor();
  }

  void _loadAppBarColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorCode = prefs.getInt('appBarColor') ?? Colors.blue.value;
    setState(() {
      _appBarColor = Color(colorCode);
    });
  }

  void _saveAppBarColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appBarColor', color.value);
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _appBarColor,
              onColorChanged: (color) {
                setState(() {
                  _appBarColor = color;
                });
                _saveAppBarColor(color);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
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
    _saveAppBarColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: _appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPickerDialog,
          ),
        ],
      ),
      drawer: CustomizedDrawer(
        onThemeModeChanged: widget.onThemeModeChanged,
        onColorChanged: _onColorChanged,
      ),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
