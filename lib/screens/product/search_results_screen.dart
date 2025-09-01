import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final List<String> filters = const ['Price', 'Name', 'In Stock', 'Category'];
  final String searchTerm = 'Apples';
  final int resultCount = 12;
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: SafeArea(
        child: Column(
          children: [
            // Filter bar
            Semantics(
              label: 'Filter options',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(filter),
                        selected: false,
                        onSelected: (selected) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Filter "$filter" selected.'),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Result count and view toggle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: 'Showing $resultCount results for $searchTerm',
                    child: Text(
                      "Showing $resultCount results for '$searchTerm'",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Grid view',
                        child: IconButton(
                          icon: const Icon(Icons.grid_view),
                          color: isGridView ? Colors.green : Colors.grey,
                          onPressed: () {
                            setState(() {
                              isGridView = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Grid view selected.'),
                              ),
                            );
                          },
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'List view',
                        child: IconButton(
                          icon: const Icon(Icons.list),
                          color: !isGridView ? Colors.green : Colors.grey,
                          onPressed: () {
                            setState(() {
                              isGridView = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('List view selected.'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Results area (placeholder)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Search results go here.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
