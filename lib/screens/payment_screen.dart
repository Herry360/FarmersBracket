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
  final bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  String? _validateCardNumber(String? value) => null;
  String? _validateExpiryDate(String? value) => null;
  String? _validateCVV(String? value) => null;
  String? _validateName(String? value) => null;
  void _submitPayment() {}

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
              DropdownButton<String>(
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
              const SizedBox(height: 16),
              if (_selectedMethod == 'Credit Card')
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                    if (_errorMessage != null)
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                    if (_isProcessing)
                      const Center(child: CircularProgressIndicator()),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                        validator: _validateCardNumber,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Expiry Date',
                                hintText: 'MM/YY',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                              maxLength: 5,
                              validator: _validateExpiryDate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                hintText: '123',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                              validator: _validateCVV,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name on Card',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 32),
                      _isProcessing
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitPayment,
                                child: const Text('Pay Now'),
                              ),
                            ),
                    ],
                  ),
                ),
              if (_selectedMethod == 'EFT') ...[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bank Details:', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        const Text('Bank: Example Bank'),
                        const Text('Account Name: FarmBracket Pty Ltd'),
                        const Text('Account Number: 1234567890'),
                        const Text('Branch Code: 12345'),
                        const SizedBox(height: 8),
                        const Text('Please use your Order ID as reference and upload proof of payment.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            // Use file_picker package for file selection
                            // import 'package:file_picker/file_picker.dart'; at top of file
                            final result = await FilePicker.platform.pickFiles(type: FileType.any);
                            if (result != null && result.files.isNotEmpty) {
                              final file = result.files.first;
                              // Example: Upload file to backend (replace with your API call)
                              try {
                                // await uploadProofOfPayment(file);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('File uploaded: ${file.name}')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Upload failed: $e')),
                                );
                              }
                            }
                          },
                          child: const Text('Upload Proof of Payment'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _submitPayment,
                  child: const Text('Confirm EFT Payment'),
                ),
              ],
              if (_selectedMethod == 'SnapScan' || _selectedMethod == 'Zapper') ...[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scan the QR code below with your $_selectedMethod app to pay.'),
                        const SizedBox(height: 8),
                        // Replace with actual QR code widget
                        // import 'package:qr_flutter/qr_flutter.dart'; at top of file
                        QrImageView(
                          data: 'https://farmbracket.com/pay/$_selectedMethod',
                          version: QrVersions.auto,
                          size: 120.0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _submitPayment,
                  child: Text('Confirm $_selectedMethod Payment'),
                ),
              ],
              if (_selectedMethod == 'Mobile Payment' || _selectedMethod == 'Cash on Delivery') ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _submitPayment,
                  child: const Text('Confirm Payment'),
                ),
              ],
              if (_isProcessing)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}