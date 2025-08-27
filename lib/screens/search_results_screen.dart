import 'package:flutter/material.dart';


class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          // Filter bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                );
              }).toList(),
            ),
          ),
          // Result count and view toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Showing $resultCount results for '$searchTerm'", style: const TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.grid_view),
                      color: isGridView ? Colors.green : Colors.grey,
                      onPressed: () {
                        setState(() {
                          isGridView = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.list),
                      color: !isGridView ? Colors.green : Colors.grey,
                      onPressed: () {
                        setState(() {
                          isGridView = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results area (placeholder)
          const Expanded(
            child: Center(child: Text('Search results go here.')),
          ),
        ],
      ),
    );
  }
}
