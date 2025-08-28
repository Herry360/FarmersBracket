import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../widgets/default_profile_placeholder.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedLanguage = 'en';
  final String _appVersion = '1.0.0+1';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _themeOptions = [
    {'label': 'System', 'value': ThemeMode.system, 'icon': Icons.settings},
    {'label': 'Light', 'value': ThemeMode.light, 'icon': Icons.light_mode},
    {'label': 'Dark', 'value': ThemeMode.dark, 'icon': Icons.dark_mode},
  ];

  final Map<String, String> _languages = {
    'en': 'English',
    'af': 'Afrikaans',
    'zu': 'Zulu',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'en';
      int themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  Future<void> _onNotificationChanged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = value;
    });
    await prefs.setBool('notificationsEnabled', value);
  }

  Future<void> _onThemeModeChanged(ThemeMode? mode) async {
    if (mode == null) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = mode;
    });
    await prefs.setInt('themeMode', mode.index);
    ref.read(themeModeProvider).setThemeMode(mode);
  }

  Future<void> _onLanguageChanged(String? value) async {
    if (value != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedLanguage = value;
      });
      await prefs.setString('language', value);
    }
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              setState(() => _isLoading = true);
              // authProvider.signOut();
              setState(() => _isLoading = false);
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _onChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change functionality coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Call delete account method
              try {
                // Replace with your actual delete logic, e.g.:
                // await authProvider.deleteAccount();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted successfully.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete account: $e')),
                );
              }
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  // No authentication logic required
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                          leading: Semantics(
                            label: 'Profile avatar',
                            child: const DefaultProfilePlaceholder(size: 28),
                          ),
                          title: const Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('No email'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit profile',
                            onPressed: () {
                              try {
                                Navigator.of(context).pushNamed('/profile_edit');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Navigation error: $e'), backgroundColor: Colors.red),
                                );
                              }
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Account Management Section
                buildSectionTitle('Account Management', Icons.manage_accounts),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: _onChangePassword,
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                  onTap: _onDeleteAccount,
                ),
                const Divider(height: 32),

                // Theme Selection Section
                buildSectionTitle('Theme', Icons.color_lens),
                ..._themeOptions.map((option) => RadioListTile<ThemeMode>(
                      value: option['value'],
                      groupValue: _themeMode,
                      title: Text(option['label']),
                      secondary: Icon(option['icon']),
                      onChanged: _onThemeModeChanged,
                    )),
                const Divider(height: 32),

                // Language Selection
                buildSectionTitle('Language', Icons.language),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('App Language'),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: _languages.entries
                        .map((entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: _onLanguageChanged,
                  ),
                ),
                const Divider(height: 32),

                // Notifications
                buildSectionTitle('Notifications', Icons.notifications),
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    try {
                      _onNotificationChanged(val);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating notifications: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  secondary: const Icon(Icons.notifications_active),
                ),
                const Divider(height: 32),

                // App Info Section
                buildSectionTitle('App Info', Icons.info),
                ListTile(
                  leading: const Icon(Icons.verified),
                  title: Text('Version $_appVersion'),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    try {
                      Navigator.of(context).pushNamed('/privacy_policy');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigation error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Terms & Conditions'),
                  onTap: () {
                    try {
                      Navigator.of(context).pushNamed('/terms');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigation error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
                const Divider(height: 32),

                // Feedback Section
                buildSectionTitle('Feedback', Icons.feedback),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Send Feedback'),
                  onTap: () {
                    try {
                      Navigator.of(context).pushNamed('/feedback');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigation error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: _onLogout,
                ),
              ],
            ),
    );
  }
}