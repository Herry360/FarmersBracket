import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/user_provider.dart';
import '../providers/products_provider.dart';
import 'farm_products_body.dart';
import 'farm_header.dart';
import '../widgets/advanced_filter_bottom_sheet.dart';

final farmProvider = Provider<Farm>((ref) {
  throw UnimplementedError('farmProvider must be overridden in ProviderScope');
});

class FarmProductsScreen extends ConsumerStatefulWidget {
  final Farm farm;
  const FarmProductsScreen({super.key, required this.farm});

  @override
  ConsumerState<FarmProductsScreen> createState() => _FarmProductsScreenState();
}

class _FarmProductsScreenState extends ConsumerState<FarmProductsScreen> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);
    final isFavorite = userState.user.favoriteFarmIds.contains(widget.farm.id);
    return ProviderScope(
      overrides: [farmProvider.overrideWithValue(widget.farm)],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.farm.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Filter',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => AdvancedFilterBottomSheet(
                    onApply: (filters) {
                      ref
                          .read(productsProvider.notifier)
                          .filterProducts(
                            categories: filters['categories'],
                            tags: filters['tags'],
                            farms: filters['farms'],
                            minPrice: filters['minPrice'],
                            maxPrice: filters['maxPrice'],
                            pickedToday: filters['pickedToday'],
                            organic: filters['organic'],
                            minRating: filters['minRating'],
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Filters applied: $filters')),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Products refreshed!')),
              );
            },
            displacement: 40,
            color: Colors.green,
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Semantics(
                  label: 'Farm header',
                  child: FarmHeader(farm: widget.farm),
                ),
                // --- Filter Chips Row ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Organic'),
                          selected: ref.watch(productsProvider).organic == true,
                          onSelected: (selected) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(organic: selected);
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('On Sale'),
                          selected:
                              ref.watch(productsProvider).onlyOnSale == true,
                          onSelected: (selected) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(onlyOnSale: selected);
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('New Arrival'),
                          selected:
                              ref.watch(productsProvider).onlyNewArrival ==
                              true,
                          onSelected: (selected) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(onlyNewArrival: selected);
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Available'),
                          selected:
                              ref.watch(productsProvider).onlyAvailable == true,
                          onSelected: (selected) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(onlyAvailable: selected);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // --- Price Range Slider ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      const Text('Price Range:'),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 1000,
                          divisions: 20,
                          value: ref.watch(productsProvider).minPrice ?? 100,
                          label:
                              'R${ref.watch(productsProvider).minPrice?.toInt() ?? 100}',
                          onChanged: (value) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(minPrice: value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite ? 'Unfavorite Farm' : 'Favorite Farm',
                    ),
                    onPressed: () {
                      final updated = List<String>.from(
                        userState.user.favoriteFarmIds,
                      );
                      if (isFavorite) {
                        updated.remove(widget.farm.id);
                      } else {
                        updated.add(widget.farm.id);
                      }
                      userNotifier.updateFavoriteFarms(updated);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? 'Removed from favorites'
                                : 'Added to favorites',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rate & Review This Farm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            child: Icon(
                              index < _selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onTap: () {
                              setState(() {
                                _selectedRating = index + 1;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      if (_pickedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.file(
                            File(_pickedImage!.path),
                            height: 100,
                          ),
                        ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Upload Photo'),
                        onPressed: () async {
                          final image = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (!mounted) return;
                          if (image != null) {
                            setState(() {
                              _pickedImage = image;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo selected for review!'),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        child: const Text('Submit Review'),
                        onPressed: () {
                          final comment = _commentController.text.trim();
                          final rating = _selectedRating;
                          final imagePath = _pickedImage?.path;
                          if (rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a rating.'),
                              ),
                            );
                            return;
                          }
                          if (comment.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a comment.'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Review submitted!\nRating: $rating\nComment: $comment${imagePath != null ? '\nPhoto attached' : ''}',
                              ),
                            ),
                          );
                          setState(() {
                            _selectedRating = 0;
                            _commentController.clear();
                            _pickedImage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Semantics(
                    label: 'Farm products',
                    child: FarmProductsBody(farm: widget.farm),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
