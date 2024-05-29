import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect_settings_ui/utils/app_thememode.dart';
import 'package:perfect_settings_ui/views/widgets/customized_drawer.dart'; // Ensure this import path is correct
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeModeChanged;
  final ValueChanged<Color> onColorChanged;

  const SettingsScreen({
    Key? key,
    required this.onThemeModeChanged,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color _currentColor = Colors.blue;
  bool _isPinEnabled = false;
  String? _pinCode;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkPin();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentColor = Color(prefs.getInt('app_color') ?? Colors.blue.value);
      _isPinEnabled = prefs.getBool('pin_enabled') ?? false;
      _pinCode = prefs.getString('pin_code');
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_color', _currentColor.value);
    await prefs.setBool('pin_enabled', _isPinEnabled);
    if (_pinCode != null) {
      await prefs.setString('pin_code', _pinCode!);
    }
  }

  void _checkPin() async {
    final prefs = await SharedPreferences.getInstance();
    final isPinEnabled = prefs.getBool('pin_enabled') ?? false;
    if (isPinEnabled) {
      final pinCode = prefs.getString('pin_code');
      if (pinCode != null) {
        _showPinCodeDialog(isSetup: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS SCREEN',
          style: GoogleFonts.aboreto(),
        ),
        backgroundColor: _currentColor,
        centerTitle: true,
      ),
      drawer: CustomizedDrawer(
        onThemeModeChanged: widget.onThemeModeChanged,
        onColorChanged: widget.onColorChanged,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              value: AppThemeMode.themeMode == ThemeMode.dark,
              onChanged: (value) {
                setState(() {
                  AppThemeMode.themeMode =
                      value ? ThemeMode.dark : ThemeMode.light;
                });
                widget.onThemeModeChanged(value);
              },
              title: const Text("THEME MODE"),
            ),
            ListTile(
              title: const Text("CHANGE APP COLOR"),
              trailing: Container(
                width: 30,
                height: 30,
                color: _currentColor,
              ),
              onTap: _showColorPickerDialog,
              
            ),
            SwitchListTile(
              value: _isPinEnabled,
              onChanged: (value) {
                setState(() {
                  _isPinEnabled = value;
                });
                if (value) {
                  _showPinCodeDialog(isSetup: true);
                } else {
                  _pinCode = null;
                  _saveSettings();
                }
              },
              title: const Text("ENABLE PIN CODE"),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _currentColor,
              onColorChanged: (color) {
                setState(() {
                  _currentColor = color;
                });
                _saveSettings();
                widget.onColorChanged(color);
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

  void _showPinCodeDialog({required bool isSetup}) {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSetup ? 'Set up your PIN' : 'Enter your PIN'),
          content: PinCodeTextField(
            length: 4,
            obscureText: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.blue.shade50,
            enableActiveFill: true,
            controller: pinController,
            onCompleted: (v) async {
              if (isSetup) {
                setState(() {
                  _pinCode = v;
                });
                await _saveSettings();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN code set successfully')),
                );
              } else {
                final prefs = await SharedPreferences.getInstance();
                final storedPin = prefs.getString('pin_code');
                if (storedPin == v) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect PIN code')),
                  );
                }
              }
            },
            appContext: context,
            onChanged: (value) {},
          ),
        );
      },
    );
  }
}
