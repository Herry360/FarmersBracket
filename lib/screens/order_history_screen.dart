import 'package:farm_bracket/screens/write_review_screen.dart';
import 'package:flutter/material.dart';
// ...existing code...
import 'order_issue_report_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _ordersFuture;
  String _selectedStatus = 'All';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Replace with actual API call
    // Add error simulation for demonstration
    // throw Exception('Network error');
    return [
      Order(
        id: 'ORD123',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        total: 49.99,
        items: [
          OrderItem(name: 'Tomatoes', quantity: 2, price: 10.0),
          OrderItem(name: 'Potatoes', quantity: 5, price: 5.0),
        ],
      ),
      Order(
        id: 'ORD124',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: OrderStatus.cancelled,
        total: 29.99,
        items: [OrderItem(name: 'Carrots', quantity: 3, price: 7.0)],
      ),
      Order(
        id: 'ORD125',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.pending,
        total: 19.99,
        items: [OrderItem(name: 'Lettuce', quantity: 1, price: 5.0)],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _isRefreshing
                ? null
                : () async {
                    setState(() => _isRefreshing = true);
                    _ordersFuture = fetchOrders();
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() => _isRefreshing = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order history refreshed!')),
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['All', 'Delivered', 'Cancelled', 'Pending']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  underline: Container(),
                  style: const TextStyle(fontSize: 16),
                  icon: const Icon(Icons.filter_list),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Error loading orders: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          onPressed: () {
                            setState(() {
                              _ordersFuture = fetchOrders();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No orders found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                List<Order> orders = snapshot.data!;
                // Filter orders by status
                if (_selectedStatus != 'All') {
                  orders = orders.where((order) {
                    switch (_selectedStatus) {
                      case 'Delivered':
                        return order.status == OrderStatus.delivered;
                      case 'Cancelled':
                        return order.status == OrderStatus.cancelled;
                      case 'Pending':
                        return order.status == OrderStatus.pending;
                      default:
                        return true;
                    }
                  }).toList();
                }
                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'No $_selectedStatus orders found.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _ordersFuture = fetchOrders();
                    });
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(order: order);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Order {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final List<OrderItem> items;
  final String? shipmentStatus;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    this.shipmentStatus,
    this.trackingNumber,
    this.estimatedDelivery,
  });
}

enum OrderStatus { delivered, cancelled, pending }

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.id}'),
                    Text('Date: ${order.date.toLocal()}'.split(' ')[0]),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Status: ${order.status.toString().split('.').last}'),
                    Text('Total: \$${order.total.toStringAsFixed(2)}'),
                    // Reorder button if order is within 90 days
                    if (DateTime.now().difference(order.date).inDays <= 90)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.repeat),
                        label: const Text('Reorder'),
                        onPressed: () {
                          // Implement reorder logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order added to cart for reorder!'),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name),
                    Text(
                      '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.receipt),
                  label: const Text('View Receipt'),
                  onPressed: () {
                    // Navigate to receipt view
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Get Help with This Order'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        final quickOptions = [
                          'Item was damaged or spoiled',
                          'Item is missing from my delivery',
                          'I received the wrong item',
                          'Other issue',
                        ];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'What issue are you experiencing?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...quickOptions.map(
                              (option) => ListTile(
                                title: Text(option),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderIssueReportScreen(
                                        orderId: order.id,
                                        products: order.items
                                            .map(
                                              (item) => {
                                                'id': item.name,
                                                'name': item.name,
                                              },
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                if (order.status == OrderStatus.delivered)
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.rate_review),
                        label: Text('Review ${item.name}'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WriteReviewScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
