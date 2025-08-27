import 'package:farm_bracket/screens/home_screen.dart';
import 'package:farm_bracket/models/farm_model.dart';
import 'package:farm_bracket/screens/farm_products_screen.dart';
import 'package:farm_bracket/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/profile_registration_screen.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String profileRegistration = '/profile-registration';
  static const String login = '/login';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String payment = '/payment';
  static const String settings = '/settings';

  static const String farmDetail = '/farm_detail';
  static const String productDetail = '/product_detail';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeScreen(),
    home: (context) => const HomeScreen(),
    cart: (context) => const CartScreen(),
    checkout: (context) => const CheckoutScreen(),
    profile: (context) => const ProfileScreen(),
    profileRegistration: (context) => const ProfileRegistrationScreen(),
    login: (context) => const LoginScreen(),
    favorites: (context) => const FavoritesScreen(),
    orders: (context) => const OrdersScreen(),
    payment: (context) => const PaymentScreen(),
    settings: (context) => const SettingsScreen(),
    farmDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      // If args is a Map, create a Farm object from it
      if (args is Farm) {
        return FarmProductsScreen(farm: args);
      } else if (args is Map) {
        // Minimal conversion for demo; ideally use fromJson
        return FarmProductsScreen(
          farm: Farm(
            id: args['id'] ?? '',
            name: args['name'] ?? '',
            description: args['description'] ?? '',
            imageUrl: args['image'] ?? '',
            rating: args['rating'] is double ? args['rating'] : double.tryParse(args['rating'].toString()) ?? 0.0,
            distance: args['distance'] is double ? args['distance'] : double.tryParse(args['distance'].toString()) ?? 0.0,
            location: args['location'] ?? '',
            category: args['category'] ?? '',
            products: [],
            price: args['price'] is double ? args['price'] : double.tryParse(args['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
            isFavorite: args['isFavorite'] ?? false,
          ),
        );
      } else {
        return const Scaffold(body: Center(child: Text('Invalid farm data')));
      }
    },
    productDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      // If args is a Product, pass it; else show error
      if (args is Product) {
        return ProductDetailScreen(product: args);
      } else if (args is Map) {
        // Minimal conversion for demo; ideally use fromJson
        return ProductDetailScreen(
          product: Product(
            id: args['id'] ?? '',
            name: args['name'] ?? '',
            description: args['description'] ?? '',
            price: args['price'] is double ? args['price'] : double.tryParse(args['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
            imageUrl: args['image'] ?? '',
            images: [],
            farmId: args['farmId'] ?? '',
            farmName: args['farm'] ?? '',
            category: args['category'] ?? '',
            unit: args['unit'] ?? '',
            isOrganic: args['isOrganic'] ?? false,
            isFeatured: args['isFeatured'] ?? false,
            isSeasonal: args['isSeasonal'] ?? false,
            rating: args['rating'] is double ? args['rating'] : double.tryParse(args['rating'].toString()) ?? 0.0,
            reviewCount: args['reviewCount'] ?? 0,
            harvestDate: null,
            stock: args['stock'] is double ? args['stock'] : double.tryParse(args['stock'].toString()) ?? 0.0,
            quantity: args['quantity'] ?? 1,
            createdAt: null,
            updatedAt: null,
            isOutOfSeason: args['isOutOfSeason'] ?? false,
            title: args['name'] ?? '',
          ),
        );
      } else {
        return const Scaffold(body: Center(child: Text('Invalid product data')));
      }
    },
  };
}