import 'package:flutter/material.dart';

class ZipCodeEntryScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ZipCodeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? errorText;
    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Zip Code'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.green[700], size: 64),
              const SizedBox(height: 16),
              Text(
                'Find Farms Near You',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your zip code to discover local farms and fresh produce.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Zip Code',
                  prefixIcon: const Icon(Icons.local_post_office),
                  errorText: errorText,
                  counterText: '',
                ),
                onChanged: (_) {
                  if (errorText != null) {
                    setState(() => errorText = null);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: const Text('Find Farms Near Me'),
                  onPressed: isLoading
                      ? null
                      : () {
                          final zip = _controller.text.trim();
                          final zipValid = RegExp(r'^\d{4,10}$').hasMatch(zip);
                          if (!zipValid) {
                            setState(() => errorText = 'Please enter a valid zip code');
                            return;
                          }
                          setState(() => isLoading = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Zip code accepted: $zip (mock)'),
                              backgroundColor: Colors.green[700],
                            ),
                          );
                          Future.delayed(const Duration(milliseconds: 800), () {
                            Navigator.pushReplacementNamed(context, '/map');
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Optionally skip onboarding
                  Navigator.pushReplacementNamed(context, '/map');
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}