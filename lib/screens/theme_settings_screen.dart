import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({Key? key}) : super(key: key);

  @override
  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late Future<SharedPreferences> _prefs;
  late ThemeMode _themeMode;
  late bool _useDynamicColor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    _themeMode = ThemeMode.system;
    _useDynamicColor = false;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final prefs = await _prefs;
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 2];
      _useDynamicColor = prefs.getBool('useDynamicColor') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    setState(() => _isLoading = true);
    final prefs = await _prefs;
    await prefs.setInt('themeMode', mode.index);
    setState(() {
      _themeMode = mode;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme mode set to ${_themeMode.name}')),
    );
  }

  Future<void> _saveDynamicColor(bool value) async {
    setState(() => _isLoading = true);
    final prefs = await _prefs;
    await prefs.setBool('useDynamicColor', value);
    setState(() {
      _useDynamicColor = value;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dynamic color ${value ? 'enabled' : 'disabled'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Theme',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Theme Settings'),
                  content: const Text('Change the app appearance and enable dynamic color if supported by your device.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Choose Theme Mode',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('System Default'),
                        value: ThemeMode.system,
                        groupValue: _themeMode,
                        onChanged: (mode) {
                          if (mode != null) _saveThemeMode(mode);
                        },
                        secondary: const Icon(Icons.settings_suggest),
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Light'),
                        value: ThemeMode.light,
                        groupValue: _themeMode,
                        onChanged: (mode) {
                          if (mode != null) _saveThemeMode(mode);
                        },
                        secondary: const Icon(Icons.light_mode),
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark'),
                        value: ThemeMode.dark,
                        groupValue: _themeMode,
                        onChanged: (mode) {
                          if (mode != null) _saveThemeMode(mode);
                        },
                        secondary: const Icon(Icons.dark_mode),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile.adaptive(
                  title: const Text('Use Dynamic Color'),
                  value: _useDynamicColor,
                  onChanged: (value) => _saveDynamicColor(value),
                  secondary: const Icon(Icons.color_lens),
                ),
                const SizedBox(height: 24),
                ListTile(
                  title: const Text('Preview'),
                  subtitle: const Text('See how your theme looks'),
                  leading: const Icon(Icons.visibility),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.onPrimary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset to Default'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await _saveThemeMode(ThemeMode.system);
                    await _saveDynamicColor(false);
                    setState(() => _isLoading = false);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings reset to default')),
                    );
                  },
                ),
              ],
            ),
    );
  }
}