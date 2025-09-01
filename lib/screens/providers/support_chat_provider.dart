import 'package:flutter/material.dart';

class SupportChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  Null get allTickets => null;

  void sendMessage(String text, {bool fromUser = true}) {
    if (text.trim().isEmpty) return;
    _messages.add(ChatMessage(
      text: text,
      timestamp: DateTime.now(),
      fromUser: fromUser,
    ));
    notifyListeners();

    if (fromUser) {
      _simulateSupportReply();
    }
  }

  void _simulateSupportReply() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _messages.add(ChatMessage(
      text: "Support: Thank you for reaching out. How can we help?",
      timestamp: DateTime.now(),
      fromUser: false,
    ));
    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool fromUser;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.fromUser,
  });
}