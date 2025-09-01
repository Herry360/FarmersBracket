import 'package:farm_bracket/models/order_model.dart';
import 'package:farm_bracket/widgets/order_history_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/empty_states/empty_orders_widget.dart';
import '../../../constants/app_strings.dart';
import '../../../providers/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await orderProvider.loadOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.orderHistory),
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingShimmer(type: ShimmerType.orderHistory);
          }

          if (orderProvider.orders.isEmpty) {
            return EmptyOrdersWidget(
              heading: AppStrings.emptyOrdersTitle,
              subtitle: AppStrings.emptyOrdersMessage,
              onActionPressed: () {
                Navigator.pushNamed(context, '/products');
              },
            );
          }

          return RefreshIndicator(
            onRefresh: _loadOrders,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orderProvider.orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return OrderHistoryCard(
                  order: order as Order,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order-details',
                      arguments: order.id,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}