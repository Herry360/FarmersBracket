import 'package:flutter/material.dart';
import 'package:farm_bracket/models/farm_model.dart';
import 'package:farm_bracket/screens/home_screen.dart';
import 'package:farm_bracket/screens/farm_products_screen.dart';
import 'package:farm_bracket/screens/product_detail_screen.dart';
import 'package:farm_bracket/screens/welcome_screen.dart';
import 'package:farm_bracket/screens/cart_screen.dart';
import 'package:farm_bracket/screens/checkout_screen.dart';
import 'package:farm_bracket/screens/favorites_screen.dart';
import 'package:farm_bracket/screens/orders_screen.dart';
import 'package:farm_bracket/screens/payment_screen.dart';
import 'package:farm_bracket/screens/profile_screen.dart';
import 'package:farm_bracket/screens/profile_registration_screen.dart';
import 'package:farm_bracket/screens/login_screen.dart';
import 'package:farm_bracket/screens/settings_screen.dart';
import 'package:farm_bracket/screens/write_review_screen.dart';
import 'package:farm_bracket/screens/map_screen.dart';

// Simple route guard widget
class RouteGuard extends StatelessWidget {
  final Widget child;
  const RouteGuard({required this.child, Key? key}) : super(key: key);

  bool get isAuthenticated {
    // TODO: Replace with real auth check
    // For demo, always true
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated) {
      return child;
    } else {
      return const Scaffold(
        body: Center(child: Text('You must be logged in to access this page')),
      );
    }
  }
}


class AppRoutes {
  // Deep linking support
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    switch (uri.path) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (context) => CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (context) => const RouteGuard(child: CheckoutScreen()));
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (context) => const RouteGuard(child: ProfileScreen()));
      case AppRoutes.profileRegistration:
        return MaterialPageRoute(builder: (context) => const ProfileRegistrationScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (context) => const RouteGuard(child: FavoritesScreen()));
      case AppRoutes.orders:
        return MaterialPageRoute(builder: (context) => const RouteGuard(child: OrdersScreen()));
      case AppRoutes.payment:
        return MaterialPageRoute(builder: (context) => const RouteGuard(child: PaymentScreen()));
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      case AppRoutes.writeReview:
        return MaterialPageRoute(builder: (context) => WriteReviewScreen());
      case AppRoutes.map:
        return MaterialPageRoute(builder: (context) => const MapScreen());
      case AppRoutes.farmDetail:
        final args = settings.arguments;
        if (args is Farm) {
          return MaterialPageRoute(builder: (context) => FarmProductsScreen(farm: args));
        }
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Invalid farm data'))));
      case AppRoutes.productDetail:
        final args = settings.arguments;
        if (args is Product) {
          return MaterialPageRoute(builder: (context) => ProductDetailScreen(product: args));
        }
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Invalid product data'))));
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Page not found'))));
    }
  }

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
  static const String writeReview = '/write_review';
  static const String map = '/map';
  static const String farmProfile = '/farm-profile';
  static const String issueReport = '/issue-report';
  static const String locationPermission = '/location-permission';
  static const String zipEntry = '/zip-entry';
  static const String trackOrder = '/track-order';
  static const String recentlyViewed = '/recently-viewed';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeScreen(),
    home: (context) => const HomeScreen(),
    cart: (context) => CartScreen(),
    checkout: (context) => const RouteGuard(child: CheckoutScreen()),
    profile: (context) => const RouteGuard(child: ProfileScreen()),
    profileRegistration: (context) => const ProfileRegistrationScreen(),
    login: (context) => const LoginScreen(),
    favorites: (context) => const RouteGuard(child: FavoritesScreen()),
    orders: (context) => const RouteGuard(child: OrdersScreen()),
    payment: (context) => const RouteGuard(child: PaymentScreen()),
    settings: (context) => const SettingsScreen(),
    writeReview: (context) => WriteReviewScreen(),
    map: (context) => const MapScreen(),
    farmDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Farm) {
        return FarmProductsScreen(farm: args);
      } else if (args is Map) {
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
            isFavorite: args['isFavorite'] ?? false, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [],
          ),
        );
      } else {
        return const Scaffold(body: Center(child: Text('Invalid farm data')));
      }
    },
    productDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Product) {
        return ProductDetailScreen(product: args);
      } else if (args is Map) {
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
            isOnSale: args['isOnSale'] ?? false,
            isNewArrival: args['isNewArrival'] ?? false,
            rating: args['rating'] is double ? args['rating'] : double.tryParse(args['rating'].toString()) ?? 0.0,
            reviewCount: args['reviewCount'] ?? 0,
            harvestDate: null,
            stock: args['stock'] is int ? args['stock'] : int.tryParse(args['stock'].toString()) ?? 0,
            createdAt: null,
            updatedAt: null,
            isOutOfSeason: args['isOutOfSeason'] ?? false,
            title: args['name'] ?? '',
            certification: args['certification'] ?? '',
            latitude: args['latitude'] is double ? args['latitude'] : double.tryParse(args['latitude']?.toString() ?? '') ?? 0.0,
            longitude: args['longitude'] is double ? args['longitude'] : double.tryParse(args['longitude']?.toString() ?? '') ?? 0.0, quantity: 0,
          ),
        );
      } else {
        return const Scaffold(body: Center(child: Text('Invalid product data')));
      }
    },
  };
}