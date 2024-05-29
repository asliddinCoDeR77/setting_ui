import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:perfect_settings_ui/views/widgets/customized_drawer.dart'; // Ensure this import path is correct

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeModeChanged;

  const HomeScreen({
    Key? key,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _appBarColor = Colors.blue;

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Color'),
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
              child: Text('Done'),
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
        title: Text('Home'),
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
      body: Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
