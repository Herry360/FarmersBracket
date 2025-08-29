import 'package:flutter/material.dart';

class AdvancedFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  const AdvancedFilterBottomSheet({super.key, required this.onApply});

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  List<String> selectedFarms = [];
  bool pickedToday = false;
  bool organic = false;
  double minPrice = 0;
  double maxPrice = 100;
  List<String> selectedCategories = [];
  List<String> selectedTags = [];
  int minRating = 0;
  final List<String> allCategories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Grains',
    'Meat',
  ];
  final List<String> allTags = [
    'Organic',
    'Local',
    'Discount',
    'New',
    'Best Seller',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Farm'),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Sunnyvale'),
                  selected: selectedFarms.contains('Sunnyvale'),
                  onSelected: (v) {
                    setState(() {
                      v
                          ? selectedFarms.add('Sunnyvale')
                          : selectedFarms.remove('Sunnyvale');
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Green Acres'),
                  selected: selectedFarms.contains('Green Acres'),
                  onSelected: (v) {
                    setState(() {
                      v
                          ? selectedFarms.add('Green Acres')
                          : selectedFarms.remove('Green Acres');
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Categories'),
            Wrap(
              spacing: 8,
              children: allCategories
                  .map(
                    (cat) => FilterChip(
                      label: Text(cat),
                      selected: selectedCategories.contains(cat),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? selectedCategories.add(cat)
                              : selectedCategories.remove(cat);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Tags'),
            Wrap(
              spacing: 8,
              children: allTags
                  .map(
                    (tag) => FilterChip(
                      label: Text(tag),
                      selected: selectedTags.contains(tag),
                      onSelected: (v) {
                        setState(() {
                          v ? selectedTags.add(tag) : selectedTags.remove(tag);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Minimum Rating'),
            Slider(
              min: 0,
              max: 5,
              divisions: 5,
              value: minRating.toDouble(),
              label: minRating == 0 ? 'Any' : minRating.toString(),
              onChanged: (v) {
                setState(() {
                  minRating = v.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Picked Today'),
              value: pickedToday,
              onChanged: (v) => setState(() => pickedToday = v),
            ),
            CheckboxListTile(
              title: const Text('Organic'),
              value: organic,
              onChanged: (v) => setState(() => organic = v ?? false),
            ),
            const SizedBox(height: 16),
            const Text('Price Range'),
            RangeSlider(
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels(
                '${minPrice.toInt()}',
                '${maxPrice.toInt()}',
              ),
              values: RangeValues(minPrice, maxPrice),
              onChanged: (values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onApply({
                  'farms': selectedFarms,
                  'categories': selectedCategories,
                  'tags': selectedTags,
                  'pickedToday': pickedToday,
                  'organic': organic,
                  'minPrice': minPrice,
                  'maxPrice': maxPrice,
                  'minRating': minRating,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
