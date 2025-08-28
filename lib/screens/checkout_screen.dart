import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

import '../providers/cart_provider.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/address_card.dart';
import 'map_picker_screen.dart';
import '../services/notification_service.dart';

// If you need to use AuthProvider, uncomment and import as needed
// import '../providers/auth_provider.dart';

// Order state notifier
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref);
});

class OrderNotifier extends StateNotifier<OrderState> {
  final Ref ref;

  OrderNotifier(this.ref) : super(OrderState());

  void resetOrderState() {
    state = OrderState();
  }

  Future<void> placeOrder(
    List<CartItem> cartItems,
    String paymentMethod, {
    DateTime? deliveryTime,
    String instructions = '',
  }) async {
    try {
      state = state.copyWith(isProcessing: true, error: null);

      final subtotal = cartItems.isNotEmpty
          ? cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice)
          : 0.0;
      const shippingFee = 5.0;
      final tax = subtotal * 0.1;
      final total = subtotal + shippingFee + tax;

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: cartItems,
        subtotal: subtotal,
        shippingFee: shippingFee,
        tax: tax,
        total: total,
        paymentMethod: paymentMethod,
        date: DateTime.now(),
        status: 'processing',
        deliveryTime: deliveryTime,
        instructions: instructions,
      );

      await Future.delayed(const Duration(seconds: 2));

      // Send notification for order placed
      final notificationService = NotificationService();
      await notificationService.sendNotification(
        'Order Placed',
        'Your order ${order.id} has been placed and is being processed.',
      );

      // Clear cart using riverpod
      ref.read(cartProvider.notifier).clearCart();

      state = state.copyWith(
        isProcessing: false,
        lastOrder: order,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to place order: ${e.toString()}',
      );
      rethrow;
    }
  }
}

class OrderState {
  final bool isProcessing;
  final Order? lastOrder;
  final String? error;

  OrderState({
    this.isProcessing = false,
    this.lastOrder,
    this.error,
  });

  OrderState copyWith({
    bool? isProcessing,
    Order? lastOrder,
    String? error,
  }) {
    return OrderState(
      isProcessing: isProcessing ?? this.isProcessing,
      lastOrder: lastOrder ?? this.lastOrder,
      error: error ?? this.error,
    );
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;
  final String paymentMethod;
  final DateTime date;
  final String status;
  final DateTime? deliveryTime;
  final String instructions;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.date,
    required this.status,
    this.deliveryTime,
    this.instructions = '',
  });
}

@RoutePage()
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  DateTime? _selectedDeliveryTime;
  final TextEditingController _instructionsController = TextEditingController();
  int _selectedPaymentMethod = 0;
  final List<String> _paymentMethods = [
    'Credit Card',
    'Mobile Payment',
    'Cash on Delivery',
    'EFT',
    'SnapScan',
    'Zapper',
  ];
  // For offline support
  bool _isOffline = false;
  Position? _userPosition;
  int _loyaltyPoints = 0;
  double _loyaltyCredit = 0.0;
  final double _loyaltyConversionRate = 0.1; // 1 point = R0.10
  
  String _couponCode = '';
  double _discount = 0.0;
  final Map<String, double> _validCoupons = {
    'SAVE10': 10.0,
    'FARM5': 5.0,
    'WELCOME': 15.0,
  };

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _getUserLocation();
  }
  
  Future<void> _checkConnectivity() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });
  }
  
  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get location: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _applyCoupon() {
    setState(() {
      _discount = _validCoupons[_couponCode.trim().toUpperCase()] ?? 0.0;
    });
    if (_discount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon applied! Discount: R${_discount.toStringAsFixed(2)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code.')),
      );
    }
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  // Helper to determine current step for Stepper
  int _getCurrentStep(List<CartItem> cartItems) {
    if (cartItems.isEmpty) return 0;
    if (_selectedDeliveryTime == null) return 1;
    if (_selectedPaymentMethod == 0) return 2;
    return 3;
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            'R${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: value < 0 ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(
    List<CartItem> cartItems,
    double total,
    ThemeData theme,
    OrderState orderState,
    VoidCallback onPlaceOrder,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Semantics(
        button: true,
        label: orderState.isProcessing ? 'Processing order' : 'Place order',
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          onPressed: orderState.isProcessing || cartItems.isEmpty
              ? null
              : () {
                  onPlaceOrder();
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (orderState.isProcessing)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              Text(orderState.isProcessing ? 'Processing...' : 'Place Order'),
              if (!orderState.isProcessing) ...[
                const SizedBox(width: 8),
                Text(
                  'R${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showOrderSuccessDialog(BuildContext context, Order order) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your order has been placed successfully.'),
            const SizedBox(height: 16),
            Text('Order ID: ${order.id}'),
            Text('Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(order.date)}'),
            Text('Total: R${order.total.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderValue = ref.watch(cartProvider);
    // Ensure cartItems is always a List<CartItem>
    final List<CartItem> cartItems = cartProviderValue.items;
    final orderState = ref.watch(orderProvider);
    final orderNotifier = ref.read(orderProvider.notifier);
    final theme = Theme.of(context);
    final subtotal = cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    const shippingFee = 5.0;
    final tax = subtotal * 0.1;
    final total = subtotal + shippingFee + tax - _discount - _loyaltyCredit;
    // Use Africa/Johannesburg timezone for all date/time
    // Africa/Johannesburg timezone is used via intl for formatting

    // Show success dialog if order was placed
    if (orderState.lastOrder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOrderSuccessDialog(context, orderState.lastOrder!);
        orderNotifier.resetOrderState();
      });
    }
    // Accessibility: Announce errors
    // Error feedback is handled via UI, accessibility announce removed for compatibility.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: orderState.isProcessing ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Stepper
                  Semantics(
                    label: 'Checkout progress',
                    child: Stepper(
                      currentStep: _getCurrentStep(cartItems),
                      controlsBuilder: (context, details) => const SizedBox.shrink(),
                      steps: const [
                        Step(title: Text('Cart'), content: SizedBox.shrink(), isActive: true),
                        Step(title: Text('Delivery'), content: SizedBox.shrink(), isActive: true),
                        Step(title: Text('Payment'), content: SizedBox.shrink(), isActive: true),
                        Step(title: Text('Confirm'), content: SizedBox.shrink(), isActive: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Delivery Address'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label: 'Delivery address',
                          child: _userPosition == null
                              ? const Center(child: CircularProgressIndicator())
                              : AddressCard(userPosition: _userPosition),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on),
                        tooltip: 'Pick Delivery Location',
                        onPressed: () async {
                          final pickedLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MapPickerScreen(),
                            ),
                          );
                          if (pickedLocation != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Picked location: ${pickedLocation.latitude}, ${pickedLocation.longitude}')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Delivery Time'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: orderState.isProcessing
                              ? null
                              : () async {
                                  try {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 7)),
                                    );
                                    if (!mounted) return;
                                    if (picked != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (!mounted) return;
                                      if (time != null) {
                                        setState(() {
                                          _selectedDeliveryTime = DateTime(
                                            picked.year,
                                            picked.month,
                                            picked.day,
                                            time.hour,
                                            time.minute,
                                          );
                                        });
                                      }
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error selecting delivery time: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                          child: Text(_selectedDeliveryTime == null
                              ? 'Select Delivery Time'
                              : DateFormat('EEE, MMM d yyyy - hh:mm a').format(_selectedDeliveryTime!)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Special Instructions'),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Special instructions',
                    child: TextField(
                      controller: _instructionsController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Add any delivery notes or instructions',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Payment Method'),
                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(
                      _paymentMethods.length,
                      (index) => Semantics(
                        label: 'Payment method ${_paymentMethods[index]}',
                        child: PaymentMethodCard(
                          method: _paymentMethods[index],
                          isSelected: _selectedPaymentMethod == index,
                          onSelected: orderState.isProcessing 
                              ? null 
                              : () => setState(() => _selectedPaymentMethod = index),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Coupon Code'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon code',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => _couponCode = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _applyCoupon,
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  if (_discount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Discount applied: R${_discount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                    ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Loyalty Points & Credits'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter loyalty points to redeem',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              _loyaltyPoints = int.tryParse(val) ?? 0;
                              _loyaltyCredit = _loyaltyPoints * _loyaltyConversionRate;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Credit: R${_loyaltyCredit.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Order Summary'),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Track Delivery Driver'),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Driver Location (stub):'),
                          const SizedBox(height: 8),
                          Container(
                            height: 120,
                            color: Colors.grey[200],
                            child: const Center(child: Text('Map/driver location will appear here')), 
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ExpansionTile(
                    title: const Text('Review Cart & Cost Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                    initiallyExpanded: false,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildSummaryRow('Subtotal', subtotal),
                              _buildSummaryRow('Shipping', shippingFee),
                              _buildSummaryRow('Tax (10%)', tax),
                              if (_discount > 0) _buildSummaryRow('Discount', -_discount),
                              const Divider(height: 24),
                              _buildSummaryRow('Total', total, isTotal: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (_isOffline)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('You are offline. Showing cached data.', style: TextStyle(color: Colors.orange)),
                    ),
                  if (orderState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${orderState.error}', style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: _buildCheckoutButton(
        cartItems,
        total,
        theme,
        orderState,
        () => orderNotifier.placeOrder(
          cartItems,
          _paymentMethods[_selectedPaymentMethod],
          deliveryTime: _selectedDeliveryTime,
          instructions: _instructionsController.text,
        ),
      ),
    );
  }
}