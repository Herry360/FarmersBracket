import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserState {
  final UserModel user;
  final double? latitude;
  final double? longitude;
  UserState({required this.user, this.latitude, this.longitude});
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(UserModel initialUser)
      : super(UserState(user: initialUser));

  void updateLocation(double lat, double lon) {
  state = UserState(user: state.user, latitude: lat, longitude: lon);
  // Persist location to Hive
  final settingsBox = Hive.box('settings');
  settingsBox.put('user_latitude', lat);
  settingsBox.put('user_longitude', lon);
  }

  void updateCommunicationPreferences(List<String> prefs) {
    state = UserState(
      user: UserModel(
        id: state.user.id,
        name: state.user.name,
        email: state.user.email,
        phone: state.user.phone,
        address: state.user.address,
        communicationPreferences: prefs,
        dietaryPreferences: state.user.dietaryPreferences,
        allergies: state.user.allergies,
        favoriteFarmIds: state.user.favoriteFarmIds,
      ),
    );
  }

  void updateDietaryPreferences(List<String> prefs) {
    state = UserState(
      user: UserModel(
        id: state.user.id,
        name: state.user.name,
        email: state.user.email,
        phone: state.user.phone,
        address: state.user.address,
        communicationPreferences: state.user.communicationPreferences,
        dietaryPreferences: prefs,
        allergies: state.user.allergies,
        favoriteFarmIds: state.user.favoriteFarmIds,
      ),
    );
  }

  void updateAllergies(List<String> allergies) {
    state = UserState(
      user: UserModel(
        id: state.user.id,
        name: state.user.name,
        email: state.user.email,
        phone: state.user.phone,
        address: state.user.address,
        communicationPreferences: state.user.communicationPreferences,
        dietaryPreferences: state.user.dietaryPreferences,
        allergies: allergies,
        favoriteFarmIds: state.user.favoriteFarmIds,
      ),
    );
  }

  void updateFavoriteFarms(List<String> farmIds) {
    state = UserState(
      user: UserModel(
        id: state.user.id,
        name: state.user.name,
        email: state.user.email,
        phone: state.user.phone,
        address: state.user.address,
        communicationPreferences: state.user.communicationPreferences,
        dietaryPreferences: state.user.dietaryPreferences,
        allergies: state.user.allergies,
        favoriteFarmIds: farmIds,
      ),
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  // Replace with actual user loading logic
  return UserNotifier(UserModel(
    id: 'user1',
    name: 'Collen Siyabonga',
    email: 'collen@example.com',
    phone: '081 234 5678',
    address: '123 Main St',
  ));
});
