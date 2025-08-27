import 'package:flutter/material.dart';

class FarmProductsSearch extends StatefulWidget {
  const FarmProductsSearch({super.key});

  @override
  @override
  State<FarmProductsSearch> createState() => _FarmProductsSearchState();
}

class _FarmProductsSearchState extends State<FarmProductsSearch> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _allProducts = [
    {'name': 'Tomato', 'category': 'Vegetable', 'price': 2.5},
    {'name': 'Apple', 'category': 'Fruit', 'price': 3.0},
    {'name': 'Carrot', 'category': 'Vegetable', 'price': 1.5},
    {'name': 'Banana', 'category': 'Fruit', 'price': 2.0},
    {'name': 'Potato', 'category': 'Vegetable', 'price': 1.0},
    {'name': 'Orange', 'category': 'Fruit', 'price': 2.8},
    {'name': 'Broccoli', 'category': 'Vegetable', 'price': 2.2},
    {'name': 'Strawberry', 'category': 'Fruit', 'price': 4.0},
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterProducts();
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesCategory = _selectedCategory == 'All' ||
            product['category'] == _selectedCategory;
        final matchesQuery =
            product['name'].toLowerCase().contains(query);
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  void _onCategoryChanged(String? category) {
    if (category == null) return;
    setState(() {
      _selectedCategory = category;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Products Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'All';
                _filteredProducts = List.from(_allProducts);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildCategoryDropdown(),
            const SizedBox(height: 12),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Search products',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = ['All', 'Vegetable', 'Fruit'];
    return Row(
      children: [
        const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _selectedCategory,
          items: categories
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ))
              .toList(),
          onChanged: _onCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (_filteredProducts.isEmpty) {
      return const Center(child: Text('No products found.'));
    }
    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(product['name'][0]),
            ),
            title: Text(product['name']),
            subtitle: Text('${product['category']} • \$${product['price']}'),
            trailing: const Icon(Icons.shopping_cart),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected ${product['name']}')),
              );
            },
          ),
        );
      },
    );
  }
}