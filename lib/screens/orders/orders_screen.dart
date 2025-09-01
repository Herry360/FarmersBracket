import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// ...existing code...

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class Order {
  final String id;
  final String customerName;
  final DateTime date;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.customerName,
    required this.date,
    required this.total,
    required this.status,
  });
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Order>> _ordersFuture;
  // ...existing code...
  // ...existing code...

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    // UI only: return mock orders
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Order(
        id: '1',
        customerName: 'John Doe',
        date: DateTime.now(),
        total: 120.0,
        status: 'Delivered',
      ),
      Order(
        id: '2',
        customerName: 'Jane Smith',
        date: DateTime.now().subtract(const Duration(days: 1)),
        total: 80.0,
        status: 'Pending',
      ),
    ];
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = fetchOrders();
    });
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            Text('Customer: ${order.customerName}'),
            Text('Date: ${order.date.toLocal().toString().split(' ')[0]}'),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            Text('Status: ${order.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No orders found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try refreshing or check back later.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Semantics(
          label: 'Order for ${order.customerName}, status ${order.status}',
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(child: Text(order.customerName[0])),
              title: Text(
                order.customerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Order ID: ${order.id}\nDate: ${order.date.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'R${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    order.status,
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing order ${order.id}')),
                );
                _showOrderDetails(order);
              },
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing orders...')),
              );
              _refreshOrders();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerOrdersList();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading orders: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final orders = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: () async {
              _refreshOrders();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOrderList(orders),
          );
        },
      ),
    );
  }
}

// Shimmer placeholder for orders list
class ShimmerOrdersList extends StatelessWidget {
  const ShimmerOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(backgroundColor: Colors.grey.shade300),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 16,
                width: 80,
                color: Colors.grey.shade300,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 12,
                width: 120,
                color: Colors.grey.shade300,
              ),
            ),
            trailing: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 14,
                width: 40,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        );
      },
    );
  }
}
