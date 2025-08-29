import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  const AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  AddressModel copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return AddressModel(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  @override
  List<Object?> get props => [id, street, city, state, zipCode, country];

  @override
  String toString() {
    return 'AddressModel(id: $id, street: $street, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }
}