import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/text_styling.dart';
import '../../network/storage_service.dart';

class CitySearchWidget extends StatelessWidget {
  final Function(String) onCitySelected;
  final bool isLoading;

  const CitySearchWidget({
    super.key,
    required this.onCitySelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - value)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _showSearchModal(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search city...',
                      style: gStyle(
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CitySearchModal(onCitySelected: onCitySelected),
    );
  }
}

class _CitySearchModal extends StatefulWidget {
  final Function(String) onCitySelected;

  const _CitySearchModal({
    required this.onCitySelected,
  });

  @override
  _CitySearchModalState createState() => _CitySearchModalState();
}

class _CitySearchModalState extends State<_CitySearchModal> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _popularCities = [
    'London',
    'New York',
    'Tokyo',
    'Paris',
    'Dubai',
    'Singapore',
    'Sydney',
    'Mumbai',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchField(),
          ),
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildPopularCities(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for a city...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildPopularCities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Popular Cities',
            style: gStyle(
              size: 18,
              weight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _popularCities.length,
            itemBuilder: (context, index) {
              return _buildCityTile(_popularCities[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final List<String> filteredCities = _popularCities
        .where((city) =>
            city.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredCities.isEmpty ? 1 : filteredCities.length,
      itemBuilder: (context, index) {
        if (filteredCities.isEmpty) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text(_searchController.text, style: gStyle()),
            onTap: () => selectAndSaveCity(_searchController.text),
          );
        }
        return ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(filteredCities[index], style: gStyle()),
          onTap: () => selectAndSaveCity(filteredCities[index]),
        );
      },
    );
  }

  Widget _buildCityTile(String city) {
    return InkWell(
      onTap: () => selectAndSaveCity(city),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.2),
              Colors.blue.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: Colors.blue.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Text(
            city,
            style: gStyle(
              size: 16,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _selectCity(String city) {
    widget.onCitySelected(city);
    Navigator.pop(context);
  }

  Future<void> selectAndSaveCity(String city) async {
    final storageService = Get.find<StorageService>();
    await storageService.saveLastCity(city);
    _selectCity(city);
  }
}
