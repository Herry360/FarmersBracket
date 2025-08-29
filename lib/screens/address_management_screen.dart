import 'package:flutter/material.dart';
import 'map_picker_screen.dart';

/// Screen for managing user shipping addresses.
/// Usage: Navigator.push(context, MaterialPageRoute(builder: (_) => AddressManagementScreen()));
class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> addresses = [
      '123 Main St, City, Country',
      '456 Farm Rd, Village, Country',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text('Pick Location on Map'),
                onPressed: () async {
                  final pickedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                  );
                  if (pickedLocation != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Picked location: ${pickedLocation.latitude}, ${pickedLocation.longitude}',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: addresses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No addresses found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: addresses.length + 1,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      if (index < addresses.length) {
                        final address = addresses[index];
                        return Semantics(
                          label: 'Address: $address',
                          child: ListTile(
                            leading: const Icon(Icons.home),
                            title: Text(address),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit address',
                                  onPressed: () {
                                    _showEditAddressDialog(context, address);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Delete address',
                                  onPressed: () {
                                    _showDeleteAddressDialog(context, address);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Add New Address'),
                          onTap: () {
                            _showAddAddressDialog(context);
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, String address) {
    final controller = TextEditingController(text: address);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Address updated!')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAddressDialog(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Address deleted!')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Address added!')));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
