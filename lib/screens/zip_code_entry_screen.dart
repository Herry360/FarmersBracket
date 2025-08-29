import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ZipCodeEntryScreen extends StatelessWidget {
  final VoidCallback onNext;
  const ZipCodeEntryScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Zip Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Zip Code'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Continue'),
              onPressed: () async {
                // Save zip code to Hive settings box
                final settingsBox = await Hive.openBox('settings');
                await settingsBox.put('zipCode', controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Zip code saved: ${controller.text}')),
                );
                onNext();
              },
            ),
          ],
        ),
      ),
    );
  }
}
