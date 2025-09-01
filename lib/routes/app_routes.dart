import 'package:farm_bracket/models/farm_model.dart';
import 'package:farm_bracket/models/product_model.dart' as model;
import 'package:farm_bracket/screens/auth/login_screen.dart';
import 'package:farm_bracket/screens/auth/register_screen.dart';
import 'package:farm_bracket/screens/cart_screen.dart';
import 'package:farm_bracket/screens/checkout_screen.dart';
import 'package:farm_bracket/screens/farm/farm_list_screen.dart';
import 'package:farm_bracket/screens/farm/map_screen.dart';
import 'package:farm_bracket/screens/favorites_screen.dart';
import 'package:farm_bracket/screens/home/home_screen.dart';
import 'package:farm_bracket/screens/home/welcome_screen.dart';
import 'package:farm_bracket/screens/orders/order_history_screen.dart';
import 'package:farm_bracket/screens/payment_screen.dart';
import 'package:farm_bracket/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/profile/profile_screen.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  const RouteGuard({required this.child, super.key});

  bool get isAuthenticated {
    // TODO: Replace with real auth check
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
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String payment = '/payment';
  static const String map = '/map';
  static const String productDetail = '/product_detail';
  static const String farmDetail = '/farm_detail';
  static const String productList = '/product_list';
  static const String farmList = '/farm_list';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    switch (uri.path) {
      case welcome:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case cart:
        return MaterialPageRoute(builder: (context) => const CartScreen());
      case checkout:
        return MaterialPageRoute(
          builder: (context) => RouteGuard(child: CheckoutScreen()),
        );
      case profile:
        return MaterialPageRoute(
          builder: (context) => RouteGuard(child: ProfileScreen()),
        );
      case favorites:
        return MaterialPageRoute(
          builder: (context) => RouteGuard(child: FavoritesScreen()),
        );
      case orders:
        return MaterialPageRoute(
          builder: (context) => const RouteGuard(child: OrderHistoryScreen()),
        );
      case payment:
        return MaterialPageRoute(
          builder: (context) => RouteGuard(child: PaymentScreen()),
        );
      case map:
        return MaterialPageRoute(builder: (context) => const MapScreen());
      case productDetail:
        final args = settings.arguments;
        if (args is model.Product) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: args),
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Invalid product data'))),
        );
      case farmDetail:
        final args = settings.arguments;
        if (args is FarmModel) {
          // Fix: Use correct parameter name for FarmListScreen
          return MaterialPageRoute(
            builder: (context) => FarmListScreen(farmModel: args),
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Invalid farm data'))),
        );
      case productList:
        return MaterialPageRoute(builder: (context) => const ProductListScreen());
      case farmList:
        // Pass a default FarmModel if FarmListScreen does not accept null
        return MaterialPageRoute(builder: (context) => FarmListScreen(farmModel: FarmModel(id: '', name: '', location: '', size: 0, crops: [], established: DateTime(2000, 1, 1), description: '', imageUrl: '', rating: 0.0, distance: 0, category: '', products: [], price: 0, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [], isFavorite: false)));
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    cart: (context) => const CartScreen(),
    checkout: (context) => RouteGuard(child: CheckoutScreen()),
    profile: (context) => const RouteGuard(child: ProfileScreen()),
    favorites: (context) => RouteGuard(child: FavoritesScreen()),
    orders: (context) => const RouteGuard(child: OrderHistoryScreen()),
    payment: (context) => RouteGuard(child: PaymentScreen()),
    map: (context) => const MapScreen(),
    productDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is model.Product) {
        return ProductDetailScreen(product: args);
      }
      return const Scaffold(body: Center(child: Text('Invalid product data')));
    },
    farmDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is FarmModel) {
        // Fix: Use correct parameter name for FarmListScreen
        return FarmListScreen(farmModel: args);
      }
      return const Scaffold(body: Center(child: Text('Invalid farm data')));
    },
    productList: (context) => const ProductListScreen(),
    farmList: (context) => FarmListScreen(
      farmModel: FarmModel(
        id: '',
        name: '',
        location: '',
        size: 0,
        crops: [],
        established: DateTime(2000, 1, 1),
        description: '',
        imageUrl: '',
        rating: 0.0,
        distance: 0,
        category: '',
        products: [],
        price: 0,
        latitude: 0.0,
        longitude: 0.0,
        story: '',
        practiceLabels: [],
        imageUrls: [],
        isFavorite: false,
      ),
    ),
  };
}