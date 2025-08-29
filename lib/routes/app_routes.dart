import 'package:farm_bracket/screens/checkout_screen.dart';
import 'package:farm_bracket/screens/home_screen.dart';
import 'package:farm_bracket/screens/login_screen.dart';
import 'package:farm_bracket/screens/map_screen.dart';
import 'package:farm_bracket/screens/payment_screen.dart';
import 'package:farm_bracket/screens/product_detail_screen.dart';
import 'package:farm_bracket/screens/register_screen.dart';
import 'package:farm_bracket/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import '../models/farm_model.dart';
import '../models/product.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/favorites_screen.dart';
import '../screens/customer/order_history_screen.dart';
import '../screens/customer/product_list_screen.dart';
import '../screens/customer/farm_list_screen.dart';
import '../screens/profile_screen.dart';

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
          builder: (context) => const RouteGuard(child: CheckoutScreen()),
        );
      case profile:
        return MaterialPageRoute(
          builder: (context) => const RouteGuard(child: ProfileScreen()),
        );
      case favorites:
        return MaterialPageRoute(
          builder: (context) => const RouteGuard(child: FavoritesScreen()),
        );
      case orders:
        return MaterialPageRoute(
          builder: (context) => const RouteGuard(child: OrderHistoryScreen()),
        );
      case payment:
        return MaterialPageRoute(
          builder: (context) => const RouteGuard(child: PaymentScreen()),
        );
      case map:
        return MaterialPageRoute(builder: (context) => const MapScreen());
      case productDetail:
        final args = settings.arguments;
        if (args is Product) {
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
        if (args is Farm) {
          return MaterialPageRoute(
            builder: (context) => FarmListScreen(farm: args),
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Invalid farm data'))),
        );
      case productList:
        return MaterialPageRoute(builder: (context) => const ProductListScreen());
      case farmList:
        return MaterialPageRoute(builder: (context) => const FarmListScreen());
      case dashboard:
        return MaterialPageRoute(builder: (context) => const DashboardScreen());
      case addProduct:
        return MaterialPageRoute(builder: (context) => const AddProductScreen());
      case orderManagement:
        return MaterialPageRoute(builder: (context) => const OrderManagementScreen());
      case productManagement:
        return MaterialPageRoute(builder: (context) => const ProductManagementScreen());
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
    checkout: (context) => const RouteGuard(child: CheckoutScreen()),
    profile: (context) => const RouteGuard(child: ProfileScreen()),
    favorites: (context) => const RouteGuard(child: FavoritesScreen()),
    orders: (context) => const RouteGuard(child: OrderHistoryScreen()),
    payment: (context) => const RouteGuard(child: PaymentScreen()),
    map: (context) => const MapScreen(),
    productDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Product) {
        return ProductDetailScreen(product: args);
      }
      return const Scaffold(body: Center(child: Text('Invalid product data')));
    },
    farmDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Farm) {
        return FarmListScreen(farm: args);
      }
      return const Scaffold(body: Center(child: Text('Invalid farm data')));
    },
    productList: (context) => const ProductListScreen(),
    farmList: (context) => const FarmListScreen(),
    dashboard: (context) => const DashboardScreen(),
    addProduct: (context) => const AddProductScreen(),
    productManagement: (context) => const ProductManagementScreen(), // Make sure ProductManagementScreen is defined and imported
  };
}
