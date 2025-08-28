class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> communicationPreferences;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final List<String> favoriteFarmIds;
  final Map<String, dynamic>? locationData;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.communicationPreferences = const [],
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.favoriteFarmIds = const [],
    this.locationData,
  });
}
