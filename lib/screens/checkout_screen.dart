import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _paymentMethod = 'Credit Card';
  bool _isProcessing = false;

  void _submitOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
      });
      _formKey.currentState?.save();

      // Simulate order processing
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isProcessing = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Order Placed'),
          content: Text('Thank you for your purchase, $_name!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
                onSaved: (value) => _name = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your address' : null,
                onSaved: (value) => _address = value ?? '',
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(labelText: 'Payment Method'),
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'PayPal',
                    child: Text('PayPal'),
                  ),
                  DropdownMenuItem(
                    value: 'Cash on Delivery',
                    child: Text('Cash on Delivery'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value ?? 'Credit Card';
                  });
                },
              ),
              SizedBox(height: 32),
              _isProcessing
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitOrder,
                      child: Text('Place Order'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}