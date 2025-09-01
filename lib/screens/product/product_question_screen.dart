import 'package:farm_bracket/models/support_ticket_model.dart';
import 'package:farm_bracket/providers/support_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    const userId = "demo_user"; // Replace with actual user ID from auth provider
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

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productImageUrl;

  const ProductDetailsScreen({
    super.key,
    this.productName = 'Sample Product',
    this.productDescription = 'This is a detailed description of the product.',
    this.productPrice = 29.99,
    this.productImageUrl = 'https://via.placeholder.com/300',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              productImageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                productName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                productDescription,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '\$${productPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart!')),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}