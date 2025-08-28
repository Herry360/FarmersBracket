import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Credit Card';
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return 'Card number required';
    if (value.length < 16) return 'Card number must be 16 digits';
    return null;
  }
  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) return 'Expiry date required';
    // Add more validation if needed
    return null;
  }
  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) return 'CVV required';
    if (value.length < 3) return 'CVV must be 3 digits';
    return null;
  }
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name required';
    return null;
  }

  void _submitPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!'), backgroundColor: Colors.green),
        );
      });
    } else {
      setState(() {
        _errorMessage = 'Please fix errors in the form.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix errors in the form.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Payment Method:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Semantics(
                label: 'Payment method dropdown',
                child: DropdownButton<String>(
                  value: _selectedMethod,
                  items: [
                    'Credit Card',
                    'Mobile Payment',
                    'Cash on Delivery',
                    'EFT',
                    'SnapScan',
                    'Zapper',
                  ].map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  )).toList(),
                  onChanged: _isProcessing ? null : (val) {
                    setState(() => _selectedMethod = val!);
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedMethod == 'Credit Card')
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Card number field',
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Card Number'),
                          keyboardType: TextInputType.number,
                          validator: _validateCardNumber,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Expiry date field',
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                          keyboardType: TextInputType.datetime,
                          validator: _validateExpiryDate,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'CVV field',
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'CVV'),
                          keyboardType: TextInputType.number,
                          validator: _validateCVV,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Name on card field',
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Name on Card'),
                          validator: _validateName,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _isProcessing
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submitPayment,
                                child: const Text('Pay Now'),
                              ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              if (_selectedMethod == 'Mobile Payment')
                Column(
                  children: [
                    const Text('Scan the QR code below to pay with your mobile app:'),
                    const SizedBox(height: 16),
                    Center(
                      child: QrImageView(
                        data: 'https://farmbracket.com/pay',
                        version: QrVersions.auto,
                        size: 180.0,
                      ),
                    ),
                  ],
                ),
              if (_selectedMethod == 'Cash on Delivery')
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('You will pay in cash when your order is delivered.'),
                ),
              if (_selectedMethod == 'EFT')
                Column(
                  children: [
                    const Text('Upload proof of EFT payment:'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isProcessing
                          ? null
                          : () async {
                              final result = await FilePicker.platform.pickFiles();
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Proof uploaded!'), backgroundColor: Colors.green),
                                );
                              }
                            },
                      child: const Text('Upload File'),
                    ),
                  ],
                ),
              if (_selectedMethod == 'SnapScan' || _selectedMethod == 'Zapper')
                Column(
                  children: [
                    Text('Scan the QR code below to pay with $_selectedMethod:'),
                    const SizedBox(height: 16),
                    Center(
                      child: QrImageView(
                        data: 'https://farmbracket.com/pay/$_selectedMethod',
                        version: QrVersions.auto,
                        size: 180.0,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}