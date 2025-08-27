import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
    },
    {
      'name': 'PayPal',
      'icon': Icons.account_balance_wallet,
    },
    {
      'name': 'Bank Transfer',
      'icon': Icons.account_balance,
    },
  ];

  void _onMethodSelected(int index) {
    setState(() {
      _selectedMethod = index;
    });
  }

  void _onContinue() {
    // Handle payment method selection logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${_paymentMethods[_selectedMethod]['name']}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return Card(
                  child: ListTile(
                    leading: Icon(method['icon']),
                    title: Text(method['name']),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: _selectedMethod,
                      onChanged: (value) => _onMethodSelected(value!),
                    ),
                    onTap: () => _onMethodSelected(index),
                  ),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onContinue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}