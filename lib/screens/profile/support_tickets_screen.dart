import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/support_chat_provider.dart';
// ...existing code...
import 'order_support_chat_screen.dart';

class SupportTicketsScreen extends StatelessWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportChatProvider>(
      builder: (context, provider, _) {
        final tickets = provider.allTickets;
        return Scaffold(
          appBar: AppBar(title: const Text('My Support Tickets')),
          body: tickets.isEmpty
              ? const Center(child: Text('No support tickets found.'))
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, idx) {
                    final ticket = tickets[idx];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text('Order #${ticket.orderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Issue: ${ticket.issueType}'),
                            Text('Status: ${ticket.status}'),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderSupportChatScreen(ticketId: ticket.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
