import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

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
  final SupabaseService _supabaseService = SupabaseService();
  final String _userId = 'CURRENT_USER_ID'; // Replace with actual user id

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    final data = await _supabaseService.fetchOrders(_userId);
    return data.map<Order>((item) => Order(
      id: item['id'],
      customerName: item['customerName'] ?? '',
      date: item['date'] != null ? DateTime.tryParse(item['date']) ?? DateTime.now() : DateTime.now(),
      total: (item['total'] ?? 0.0).toDouble(),
      status: item['status'] ?? '',
    )).toList();
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
      return const Center(child: Text('No orders found.'));
    }
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(order.customerName[0]),
          ),
          title: Text(order.customerName),
          subtitle: Text(
            'Order ID: ${order.id}\nDate: ${order.date.toLocal().toString().split(' ')[0]}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('\$${order.total.toStringAsFixed(2)}'),
              Text(
                order.status,
                style: TextStyle(
                  color: _statusColor(order.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => _showOrderDetails(order),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading orders: ${snapshot.error}'),
            );
          }
          final orders = snapshot.data ?? [];
          return _buildOrderList(orders);
        },
      ),
    );
  }
}