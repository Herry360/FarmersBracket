import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/support_chat_provider.dart';
import '../models/support_ticket_model.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
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
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    final ticket = SupportTicket(
      id: ticketId,
      orderId: '', // Fill if you have order context
      userId: userId,
      issueType: subject.isNotEmpty ? subject : 'General',
      status: 'Submitted',
      createdAt: DateTime.now(),
      messages: [
        SupportMessage(
          senderId: userId,
          senderName: 'You',
          content: message,
          timestamp: DateTime.now(),
          isFromSupport: false,
        ),
      ],
      affectedProductIds: [],
      description: message,
      imageUrl: null,
    );
    supportProvider.addTicket(ticket);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _submitted = false;
        _subjectController.clear();
        _messageController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support request submitted!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 5,
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
