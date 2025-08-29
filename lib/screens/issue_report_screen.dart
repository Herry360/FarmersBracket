import 'package:flutter/material.dart';

class IssueReportScreen extends StatefulWidget {
  const IssueReportScreen({super.key});

  @override
  State<IssueReportScreen> createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  String? selectedIssue;
  bool showPhotoPicker = false;
  String? receivedItem;
  final List<String> recentOrderItems = ['Tomatoes', 'Carrots', 'Lettuce'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Issue Type:', style: TextStyle(fontSize: 18)),
            ...[
              'Wrong Item',
              'Poor Quality',
              'Missing Item',
              'Late Delivery',
            ].map(
              (issue) => ListTile(
                title: Text(issue),
                leading: Radio<String>(
                  value: issue,
                  groupValue: selectedIssue,
                  onChanged: (v) {
                    setState(() {
                      selectedIssue = v;
                      showPhotoPicker = v == 'Poor Quality';
                    });
                  },
                ),
              ),
            ),
            if (selectedIssue == 'Wrong Item')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'What did you actually receive?',
                    border: OutlineInputBorder(),
                  ),
                  value: receivedItem,
                  items: recentOrderItems
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => receivedItem = v),
                ),
              ),
            if (showPhotoPicker)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Add Photo Evidence'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo picker opened (mock)'),
                      ),
                    );
                  },
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed:
                  selectedIssue == null ||
                      (selectedIssue == 'Wrong Item' && receivedItem == null)
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Issue Submitted'),
                          content: Text(
                            selectedIssue == 'Wrong Item' ||
                                    selectedIssue == 'Missing Item'
                                ? "We're sorry! R15.00 credit has been added to your account for your next order."
                                : 'Thank you for your feedback!',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
