import 'package:flutter/material.dart';
import '../models/support_ticket_model.dart';

class SupportChatProvider extends ChangeNotifier {
  final Map<String, SupportTicket> _tickets = {};

  List<SupportTicket> get allTickets => _tickets.values.toList();

  SupportTicket? getTicketById(String id) => _tickets[id];

  void addTicket(SupportTicket ticket) {
    _tickets[ticket.id] = ticket;
    notifyListeners();
  }

  void addMessage(String ticketId, SupportMessage message) {
    final ticket = _tickets[ticketId];
    if (ticket != null) {
      ticket.messages.add(message);
      notifyListeners();
    }
  }

  void updateTicketStatus(String ticketId, String status) {
    final ticket = _tickets[ticketId];
    if (ticket != null) {
      final updatedTicket = SupportTicket(
        id: ticket.id,
        orderId: ticket.orderId,
        userId: ticket.userId,
        issueType: ticket.issueType,
        status: status,
        createdAt: ticket.createdAt,
        messages: ticket.messages,
        affectedProductIds: ticket.affectedProductIds,
        description: ticket.description,
        imageUrl: ticket.imageUrl,
      );
      _tickets[ticketId] = updatedTicket;
      notifyListeners();
    }
  }

  void loadMockTickets(List<SupportTicket> tickets) {
    for (var ticket in tickets) {
      _tickets[ticket.id] = ticket;
    }
    notifyListeners();
  }
}

