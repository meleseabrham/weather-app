import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../weather/data/services/city_search_service.dart';

class SearchBarWithSuggestions extends StatefulWidget {
  final Function(String) onSearch;
  final CitySearchService citySearchService;

  const SearchBarWithSuggestions({
    super.key,
    required this.onSearch,
    required this.citySearchService,
  });

  @override
  State<SearchBarWithSuggestions> createState() => _SearchBarWithSuggestionsState();
}

class _SearchBarWithSuggestionsState extends State<SearchBarWithSuggestions> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<CitySuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Set new timer for debouncing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _getSuggestions();
    });
  }

  Future<void> _getSuggestions() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await widget.citySearchService.getCitySuggestions(_controller.text);
      setState(() {
        _suggestions = suggestions;
        _showSuggestions = suggestions.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting suggestions: $e');
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _isLoading = false;
      });
    }
  }

  void _onSuggestionSelected(CitySuggestion suggestion) {
    // Use the full display name for better accuracy
    _controller.text = suggestion.displayName;
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
    // Pass the exact name from the API for better accuracy
    widget.onSearch(suggestion.name);
  }

  void _onSearchSubmitted() {
    if (_controller.text.trim().isNotEmpty) {
      // Clean the search query before submitting
      final cleanQuery = _controller.text.trim();
      
      // If there are suggestions, use the first one for better accuracy
      if (_suggestions.isNotEmpty) {
        widget.onSearch(_suggestions.first.name);
      } else {
        // Otherwise, try to clean the query and search
        final cleanedQuery = _cleanQuery(cleanQuery);
        widget.onSearch(cleanedQuery);
      }
      
      _focusNode.unfocus();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  String _cleanQuery(String query) {
    // Remove common suffixes that might cause issues
    String cleaned = query.trim();
    
    // Remove "City" suffix if present
    if (cleaned.toLowerCase().endsWith(' city')) {
      cleaned = cleaned.substring(0, cleaned.length - 5);
    }
    
    // Remove "Town" suffix if present
    if (cleaned.toLowerCase().endsWith(' town')) {
      cleaned = cleaned.substring(0, cleaned.length - 5);
    }
    
    // Remove "Village" suffix if present
    if (cleaned.toLowerCase().endsWith(' village')) {
      cleaned = cleaned.substring(0, cleaned.length - 8);
    }
    
    // Remove "District" suffix if present
    if (cleaned.toLowerCase().endsWith(' district')) {
      cleaned = cleaned.substring(0, cleaned.length - 9);
    }
    
    // Remove extra spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    return cleaned;
  }

  Widget? _getCountryFlag(String countryCode) {
    final flagMap = {
      'US': '🇺🇸', 'GB': '🇬🇧', 'UK': '🇬🇧', 'CA': '🇨🇦', 'AU': '🇦🇺',
      'DE': '🇩🇪', 'FR': '🇫🇷', 'IT': '🇮🇹', 'ES': '🇪🇸', 'JP': '🇯🇵',
      'CN': '🇨🇳', 'IN': '🇮🇳', 'BR': '🇧🇷', 'RU': '🇷🇺', 'ET': '🇪🇹',
      'KE': '🇰🇪', 'NG': '🇳🇬', 'ZA': '🇿🇦', 'EG': '🇪🇬', 'MA': '🇲🇦',
      'TN': '🇹🇳', 'Ethiopia': '🇪🇹', 'Kenya': '🇰🇪', 'Nigeria': '🇳🇬',
      'South Africa': '🇿🇦', 'Egypt': '🇪🇬', 'Morocco': '🇲🇦', 'Tunisia': '🇹🇳',
      'United States': '🇺🇸', 'United Kingdom': '🇬🇧', 'Canada': '🇨🇦',
      'Australia': '🇦🇺', 'Germany': '🇩🇪', 'France': '🇫🇷', 'Italy': '🇮🇹',
      'Spain': '🇪🇸', 'Japan': '🇯🇵', 'China': '🇨🇳', 'India': '🇮🇳',
      'Brazil': '🇧🇷', 'Russia': '🇷🇺'
    };

    final flag = flagMap[countryCode];
    if (flag != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ThemeConstants.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          flag,
          style: ThemeConstants.caption.copyWith(fontSize: 12),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingM,
            vertical: ThemeConstants.spacingS,
          ),
          decoration: BoxDecoration(
            color: ThemeConstants.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
            border: Border.all(
              color: ThemeConstants.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: ThemeConstants.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: ThemeConstants.spacingS),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: ThemeConstants.bodyMedium.copyWith(
                    color: ThemeConstants.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for any city, town, or country...',
                    hintStyle: ThemeConstants.bodyMedium.copyWith(
                      color: ThemeConstants.white.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spacingS,
                      vertical: ThemeConstants.spacingXS,
                    ),
                  ),
                  onSubmitted: (_) => _onSearchSubmitted(),
                  textInputAction: TextInputAction.search,
                ),
              ),
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: ThemeConstants.white.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: ThemeConstants.white.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: _onSearchSubmitted,
              ),
            ],
          ),
        ),
        
        // Suggestions List
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: ThemeConstants.spacingXS),
            decoration: BoxDecoration(
              color: ThemeConstants.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(ThemeConstants.spacingM),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _suggestions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(ThemeConstants.spacingM),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                color: ThemeConstants.darkGrey.withOpacity(0.5),
                                size: 32,
                              ),
                              const SizedBox(height: ThemeConstants.spacingS),
                              Text(
                                'No cities found',
                                style: ThemeConstants.bodyMedium.copyWith(
                                  color: ThemeConstants.darkGrey.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: ThemeConstants.spacingXS),
                              Text(
                                'Try searching for a different city or check spelling',
                                style: ThemeConstants.bodySmall.copyWith(
                                  color: ThemeConstants.darkGrey.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = _suggestions[index];
                            return ListTile(
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: ThemeConstants.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.location_city,
                                  color: ThemeConstants.primaryBlue,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                suggestion.name,
                                style: ThemeConstants.bodyMedium.copyWith(
                                  color: ThemeConstants.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                suggestion.state.isNotEmpty 
                                    ? '${suggestion.state}, ${suggestion.country}'
                                    : suggestion.country,
                                style: ThemeConstants.bodySmall.copyWith(
                                  color: ThemeConstants.darkGrey.withOpacity(0.7),
                                ),
                              ),
                              trailing: _getCountryFlag(suggestion.country),
                              onTap: () => _onSuggestionSelected(suggestion),
                              dense: true,
                            );
                          },
                        ),
            ),
          ),
      ],
    );
  }
} 