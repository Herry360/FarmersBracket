import 'package:farm_bracket/models/support_ticket_model.dart';
import 'package:farm_bracket/providers/support_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSupportChatScreen extends StatefulWidget {
  final String ticketId;

  const OrderSupportChatScreen({super.key, required this.ticketId});

  @override
  _OrderSupportChatScreenState createState() => _OrderSupportChatScreenState();
}

class _OrderSupportChatScreenState extends State<OrderSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final provider = Provider.of<SupportChatProvider>(context, listen: false);
    final ticket = provider.getTicketById(widget.ticketId);
    if (ticket != null && _messageController.text.trim().isNotEmpty) {
      final message = SupportMessage(
        senderId: 'currentUserId', // Replace with actual user ID
        senderName: 'You',
        content: _messageController.text.trim(),
        timestamp: DateTime.now(),
        isFromSupport: false,
      );
      provider.addMessage(widget.ticketId, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportChatProvider>(
      builder: (context, provider, _) {
        final ticket = provider.getTicketById(widget.ticketId);
        if (ticket == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Support Chat')),
            body: const Center(child: Text('Ticket not found.')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Support Chat for Order #${ticket.orderId}'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ticket.messages.length,
                  itemBuilder: (context, idx) {
                    final msg = ticket.messages[idx];
                    final isMe = !msg.isFromSupport;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.senderName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(msg.content),
                            const SizedBox(height: 2),
                            Text(
                              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
