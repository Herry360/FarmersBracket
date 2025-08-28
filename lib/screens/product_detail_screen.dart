import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/provenance_card.dart';
import '../widgets/sticky_add_to_cart_bar.dart';
import '../services/hive_service.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);
  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add product to recently viewed
    HiveService.addRecentlyViewedProduct(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFavorite = favoritesNotifier.isFavorite(widget.product.id);
    final cartNotifier = ref.read(cartProvider.notifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 2, // Adjust based on your number of tabs
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.product.name),
              actions: [
                Semantics(
                  button: true,
                  label: isFavorite ? 'Unfavourite' : 'Favourite',
                  child: IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      if (isFavorite) {
                        favoritesNotifier.removeFavorite(widget.product.id);
                      } else {
                        favoritesNotifier.addFavorite(widget.product);
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Details'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
            body: Column(
              children: [
                // Provenance Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ProvenanceCard(
                    farmName: widget.product.farmName,
                    farmLogoUrl: widget.product.imageUrl,
                    distanceKm: 0,
                    farmerName: '',
                  ),
                ),
                // Harvest Date & Delivery Estimate
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      widget.product.harvestDate != null
                          ? Text('Harvested on: ${widget.product.harvestDate!.day}/${widget.product.harvestDate!.month}/${widget.product.harvestDate!.year}', style: const TextStyle(fontWeight: FontWeight.bold))
                          : const Text('Harvest date not available', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Details Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.description),
                            // Add more product details here
                          ],
                        ),
                      ),
                      // Reviews Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Submit a Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(5, (index) => const Icon(Icons.star_border)),
                            ),
                            const SizedBox(height: 8),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Comment',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Upload Photo'),
                              onPressed: _pickImage,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              child: const Text('Submit Review'),
                              onPressed: () {
                                if (_pickedImage != null) {
                                  // You can upload _pickedImage.path to your backend or storage
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(_pickedImage != null ? 'Review with photo submitted!' : 'Review submitted!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: StickyAddToCartBar(
              price: widget.product.price,
              onAddToCart: () {
                cartNotifier.addToCart(widget.product as CartItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart!')),
                );
              },
            ),
          ),
              ),
            );
        }
      }
