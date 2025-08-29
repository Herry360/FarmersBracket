import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/farm_card.dart';
import '../../../widgets/farm_search_bar.dart';
import '../../../constants/app_strings.dart';
import '../../../providers/farm_provider.dart';

class FarmListScreen extends StatefulWidget {
  const FarmListScreen({super.key});

  @override
  State<FarmListScreen> createState() => _FarmListScreenState();
}

class _FarmListScreenState extends State<FarmListScreen> {
  late FarmProvider _farmProvider;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFarms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFarms() async {
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    await farmProvider.loadFarms();
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    _farmProvider.searchFarms(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    _farmProvider.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    _farmProvider = Provider.of<FarmProvider>(context);

    final displayedFarms = _isSearching
        ? _farmProvider.searchResults
        : _farmProvider.farms;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.nearbyFarms),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter farms',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FarmSearchBar(
              controller: _searchController,
              onClear: _clearSearch, onChanged: (String value) {  },
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const LoadingShimmer(type: ShimmerType.farmList);
                }

                if (displayedFarms == null || displayedFarms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSearching ? Icons.search_off : Icons.agriculture,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching
                              ? AppStrings.emptySearchTitle
                              : 'No farms available',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSearching
                              ? AppStrings.emptySearchMessage
                              : 'Check back later for nearby farms',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_isSearching)
                          TextButton(
                            onPressed: _clearSearch,
                            child: const Text('Clear search'),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadFarms,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedFarms.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final farm = displayedFarms[index];
                      return FarmCard(
                        farm: farm,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/farm-details',
                            arguments: farm.id,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Farms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFilterOption(
                'Organic Only',
                Icons.eco,
                _farmProvider.organicFilter,
              ),
              _buildFilterOption(
                'Local Only',
                Icons.location_on,
                _farmProvider.localFilter,
              ),
              _buildFilterOption(
                'Open Now',
                Icons.access_time,
                _farmProvider.openNowFilter,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _farmProvider.clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset Filters'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon, bool value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          if (title == 'Organic Only') {
            _farmProvider.setOrganicFilter(newValue);
          } else if (title == 'Local Only') {
            _farmProvider.setLocalFilter(newValue);
          } else if (title == 'Open Now') {
            _farmProvider.setOpenNowFilter(newValue);
          }
        },
      ),
    );
  }
}
