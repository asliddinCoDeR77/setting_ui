import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:perfect_settings_ui/views/screen/notes_screen.dart';
import 'package:perfect_settings_ui/views/screen/todo_screen.dart';
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
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> screens = [
    const Center(child: Text('HOME SCREEN')),
    const Center(child: NoteScreen()),
    const Center(
      child: TodoScreen(),
    ),
  ];
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.today_outlined), label: 'Todo'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
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
        body: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: Colors.amber,
              onDestinationSelected: _onItemTapped,
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.note_alt_sharp), label: Text('Notes')),
                NavigationRailDestination(
                    icon: Icon(Icons.today_rounded), label: Text('Todo')),
              ],
            ),
            Expanded(
                child: IndexedStack(
              index: _selectedIndex,
              children: screens,
            ))
          ],
        ));
  }
}
