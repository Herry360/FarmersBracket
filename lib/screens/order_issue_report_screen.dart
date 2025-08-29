import 'package:flutter/material.dart';
import '../models/support_ticket_model.dart';
import '../services/image_picker_service.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/support_chat_provider.dart';

class OrderIssueReportScreen extends StatefulWidget {
  final String orderId;
  final List<Map<String, dynamic>> products; // [{id, name}]

  const OrderIssueReportScreen({
    super.key,
    required this.orderId,
    required this.products,
  });

  @override
  _OrderIssueReportScreenState createState() => _OrderIssueReportScreenState();
}

class _OrderIssueReportScreenState extends State<OrderIssueReportScreen> {
  final TextEditingController _descController = TextEditingController();
  final List<String> _selectedProductIds = [];
  String? _selectedIssueType;
  String? _imagePath;

  final List<String> issueTypes = [
    'Item was damaged or spoiled',
    'Item is missing from my delivery',
    'I received the wrong item',
    'Other issue',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePickerService();
    final path = await picker.pickImage();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  void _submit() {
    final ticket = SupportTicket(
      id: UniqueKey().toString(),
      orderId: widget.orderId,
      userId: 'currentUserId', // Replace with actual user ID
      issueType: _selectedIssueType ?? '',
      status: 'Submitted',
      createdAt: DateTime.now(),
      messages: [],
      affectedProductIds: _selectedProductIds,
      description: _descController.text,
      imageUrl: _imagePath,
    );
    Provider.of<SupportChatProvider>(context, listen: false).addTicket(ticket);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Issue Submitted'),
        content: const Text(
          'Your issue has been reported and is being reviewed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order #: ${widget.orderId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Select Issue Type:'),
            ...issueTypes.map(
              (type) => RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: _selectedIssueType,
                onChanged: (val) => setState(() => _selectedIssueType = val),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select affected items:'),
            ...widget.products.map(
              (prod) => CheckboxListTile(
                title: Text(prod['name']),
                value: _selectedProductIds.contains(prod['id']),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedProductIds.add(prod['id']);
                    } else {
                      _selectedProductIds.remove(prod['id']);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Describe the issue',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _imagePath != null
                ? Image.file(File(_imagePath!), height: 120)
                : const SizedBox.shrink(),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Upload Photo'),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  _selectedIssueType != null && _selectedProductIds.isNotEmpty
                  ? _submit
                  : null,
              child: const Text('Submit Issue'),
            ),
          ],
        ),
      ),
    );
  }
}
