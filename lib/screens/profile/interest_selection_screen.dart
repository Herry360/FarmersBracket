import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InterestSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;
  const InterestSelectionScreen({super.key, required this.onNext});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final List<String> interests = [
    'Veggies',
    'Dairy',
    'Meat',
    'Bakery',
    'Fruits',
    'Eggs',
    'Honey',
    'Flowers',
  ];
  final Set<String> selectedInterests = {};

  void _saveInterests() async {
    final settingsBox = await Hive.openBox('settings');
    await settingsBox.put('interests', selectedInterests.toList());
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Interests')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are you most interested in?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: interests
                  .map(
                    (interest) => ChoiceChip(
                      label: Text(interest),
                      selected: selectedInterests.contains(interest),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedInterests.add(interest);
                          } else {
                            selectedInterests.remove(interest);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selectedInterests.isNotEmpty ? _saveInterests : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
