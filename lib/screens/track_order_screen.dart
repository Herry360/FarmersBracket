import 'package:flutter/material.dart';

// Screen for tracking order status
class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example UI for order status visualization
    final List<String> statuses = ['Processing', 'Shipped', 'Out for Delivery', 'Delivered'];
    final int currentStatus = 2; // Example: Out for Delivery

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: List.generate(statuses.length, (index) {
                return Expanded(
                  child: Column(
                    children: [
                      Icon(
                        index <= currentStatus ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: index <= currentStatus ? Colors.green : Colors.grey,
                      ),
                      Text(statuses[index]),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
