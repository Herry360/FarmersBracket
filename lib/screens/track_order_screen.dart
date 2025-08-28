import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Screen for tracking order status
class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = ['Processing', 'Shipped', 'Out for Delivery', 'Delivered'];
    const int currentStatus = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Animated delivery progress
                    Center(
                      child: SizedBox(
                        height: 180,
                        child: Semantics(
                          label: 'Animated delivery progress',
                          child: Image.network(
                            'https://assets.lottiefiles.com/packages/lf20_4kx2q32n/truck.gif',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(statuses.length, (index) {
                        return Expanded(
                          child: Semantics(
                            label: 'Status: ${statuses[index]}',
                            child: Column(
                              children: [
                                Icon(
                                  index <= currentStatus ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: index <= currentStatus ? Colors.green : Colors.grey,
                                ),
                                Text(statuses[index]),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.schedule),
                      label: const Text('Reschedule Delivery'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Select New Delivery Time', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    const TextField(
                                      decoration: InputDecoration(
                                        labelText: 'New Delivery Time',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Delivery rescheduled!')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Confirm Delivery with Photo'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Upload Delivery Confirmation Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.photo_camera),
                                      label: const Text('Upload Photo'),
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
                                        if (pickedImage != null && context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Photo Preview'),
                                              content: Image.file(
                                                File(pickedImage.path),
                                                height: 200,
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                              ],
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Photo selected for delivery confirmation!')),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      child: const Text('Confirm Delivery'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Delivery confirmed with photo!')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 32),
                    Semantics(
                      button: true,
                      label: 'Refresh order status',
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => const Center(child: CircularProgressIndicator()),
                          );
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order status refreshed!')),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Refresh Status'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
