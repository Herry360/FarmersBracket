import 'package:flutter/material.dart';

class ZipCodeEntryScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ZipCodeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Zip Code')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter your zip code to find farms near you:', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Zip Code',
                  errorText: errorText,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final zip = _controller.text.trim();
                  if (zip.isEmpty || zip.length < 4) {
                    setState(() => errorText = 'Please enter a valid zip code');
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Zip code accepted: $zip (mock)')),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushReplacementNamed(context, '/map');
                  });
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                child: const Text('Find Farms Near Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
