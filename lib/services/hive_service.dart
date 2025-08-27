import 'package:hive/hive.dart';

class HiveService {
  static Future<void> init() async {
    // Register adapters if needed
    // Hive.registerAdapter(YourAdapter());

    await Hive.openBox('auth');
    await Hive.openBox('cart');
    await Hive.openBox('favorites');
    await Hive.openBox('settings');
    await Hive.openBox('addresses');
  }

  static Future<void> clearAllData() async {
    await Hive.box('auth').clear();
    await Hive.box('cart').clear();
    await Hive.box('favorites').clear();
    await Hive.box('settings').clear();
    await Hive.box('addresses').clear();
  }

  static Future<void> saveToBox(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  static dynamic getFromBox(String boxName, String key, [dynamic defaultValue]) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);  
  }

  static Future<void> removeFromBox(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }
}
