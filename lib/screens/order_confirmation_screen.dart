import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
	final String orderNumber = 'ORD123456';
	final double total = 299.99;
	final String deliveryDate = 'Aug 30, 2025';

  const OrderConfirmationScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Order Confirmed')),
			body: Center(
				child: Padding(
					padding: const EdgeInsets.all(24.0),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							const Icon(Icons.check_circle, color: Colors.green, size: 80),
							const SizedBox(height: 24),
							const Text('Thank you for your order!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
							const SizedBox(height: 16),
							Card(
								elevation: 2,
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
								child: Padding(
									padding: const EdgeInsets.all(16.0),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text('Order #: $orderNumber', style: const TextStyle(fontSize: 18)),
											const SizedBox(height: 8),
											Text('Total: R$total', style: const TextStyle(fontSize: 18)),
											const SizedBox(height: 8),
											Text('Expected Delivery: $deliveryDate', style: const TextStyle(fontSize: 18)),
										],
									),
								),
							),
							const SizedBox(height: 32),
							ElevatedButton(
								onPressed: () {
									Navigator.of(context).pushNamed('/order_tracking');
								},
								style: ElevatedButton.styleFrom(
									padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
									backgroundColor: Colors.green,
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
								),
								child: const Text('Track Your Order', style: TextStyle(fontSize: 18)),
							),
							TextButton(
								onPressed: () {
									Navigator.of(context).pushNamedAndRemoveUntil('/products', (route) => false);
								},
								child: const Text('Continue Shopping'),
							),
						],
					),
				),
			),
		);
	}
}
