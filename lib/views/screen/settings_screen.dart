import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:perfect_settings_ui/utils/app_thememode.dart';
import 'package:perfect_settings_ui/views/screen/home_screen.dart';
import 'package:perfect_settings_ui/views/widgets/customized_drawer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isFingerprintEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentColor = Color(prefs.getInt('app_color') ?? Colors.blue.value);
      _isPinEnabled = prefs.getBool('is_pin_enabled') ?? false;
      _isFingerprintEnabled = prefs.getBool('is_fingerprint_enabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_color', _currentColor.value);
    await prefs.setBool('is_pin_enabled', _isPinEnabled);
    await prefs.setBool('is_fingerprint_enabled', _isFingerprintEnabled);
  }

  Future<void> _setPin() async {
    final TextEditingController pinController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set PIN'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Enter PIN',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_pin', pinController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reopenApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
              onChanged: (value) async {
                setState(() {
                  _isPinEnabled = value;
                });
                if (value) {
                  await _setPin();
                }
                await _saveSettings();
              },
              title: const Text("ENABLE PIN CODE"),
            ),
            SwitchListTile(
              value: _isFingerprintEnabled,
              onChanged: (value) async {
                setState(() {
                  _isFingerprintEnabled = value;
                });
                await _saveSettings();
              },
              title: const Text("ENABLE FINGERPRINT"),
            ),
            if (_isPinEnabled && _isFingerprintEnabled)
              ElevatedButton(
                onPressed: _reopenApp,
                child: const Text('Re-open App'),
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
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    final LocalAuthentication auth = LocalAuthentication();

    Future<bool> _authenticate() async {
      final isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) {
        return false;
      }
      try {
        return await auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
      } catch (e) {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please enter your PIN and use fingerprint to login'),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter PIN',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final savedPin = prefs.getString('user_pin');
                final isAuthenticated = await _authenticate();
                if (pinController.text == savedPin && isAuthenticated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        onThemeModeChanged: (bool value) {},
                        onLocaleChanged: (Locale value) {},
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Invalid PIN or authentication failed')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
