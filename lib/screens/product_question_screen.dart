import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/support_chat_provider.dart';
import '../models/support_ticket_model.dart';

class ProductQuestionScreen extends StatefulWidget {
  final String productName;
  const ProductQuestionScreen({super.key, this.productName = 'Product'});

  @override
  State<ProductQuestionScreen> createState() => _ProductQuestionScreenState();
}

class _ProductQuestionScreenState extends State<ProductQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool _submitted = false;

  void _submit() {
    setState(() {
      _submitted = true;
    });

    final supportProvider = Provider.of<SupportChatProvider>(
      context,
      listen: false,
    );
    const userId =
        "demo_user"; // Replace with actual user ID from auth provider
    final ticketId = DateTime.now().millisecondsSinceEpoch.toString();
    final question = _questionController.text.trim();

    final ticket = SupportTicket(
      id: ticketId,
      orderId: '',
      userId: userId,
      issueType: 'Product Question',
      status: 'Submitted',
      createdAt: DateTime.now(),
      messages: [
        SupportMessage(
          senderId: userId,
          senderName: 'You',
          content: question,
          timestamp: DateTime.now(),
          isFromSupport: false,
        ),
      ],
      affectedProductIds: [widget.productName],
      description: question,
      imageUrl: null,
    );
    supportProvider.addTicket(ticket);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _submitted = false;
        _questionController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your question has been sent!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ask About ${widget.productName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ask a question about this product:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Your question'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitted ? null : _submit,
              child: Text(_submitted ? 'Submitting...' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
