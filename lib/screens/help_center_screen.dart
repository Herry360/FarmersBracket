import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'question': 'How do I place an order?', 'answer': 'Browse products, add to cart, and checkout.'},
      {'question': 'How do I track my delivery?', 'answer': 'Go to Order History and select Track Order.'},
      {'question': 'How do I request a refund?', 'answer': 'Report an issue from your order card.'},
      {'question': 'How do I contact support?', 'answer': 'Use the chat or callback request below.'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center & FAQs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ...faqs.map((faq) => ExpansionTile(
                title: Text(faq['question']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(faq['answer']!),
                  ),
                ],
              )),
          const SizedBox(height: 32),
          const Text('Need more help?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.chat),
            label: const Text('Chat with Support'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportChatScreen()));
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.phone),
            label: const Text('Request Callback'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Request Callback'),
                  content: const Text('Our support team will call you back soon.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({Key? key}) : super(key: key);

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'support', 'text': 'Support: Hi! How can we help you today?'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                final isSupport = msg['sender'] == 'support';
                return ListTile(
                  leading: isSupport ? const Icon(Icons.support_agent) : const Icon(Icons.person),
                  title: Text(msg['text'] ?? ''),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Send'),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    setState(() {
                      _messages.add({'sender': 'user', 'text': 'You: $text'});
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
