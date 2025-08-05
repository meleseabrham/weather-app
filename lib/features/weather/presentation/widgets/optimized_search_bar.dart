import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/theme_constants.dart';
import '../../data/services/nominatim_service.dart';
import '../../data/services/weather_cache_service.dart';
import '../../data/services/city_search_service.dart';
import '../providers/weather_provider.dart';

class OptimizedSearchBar extends StatefulWidget {
  const OptimizedSearchBar({super.key});

  @override
  State<OptimizedSearchBar> createState() => _OptimizedSearchBarState();
}

class _OptimizedSearchBarState extends State<OptimizedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isLoading = false;
  List<dynamic> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text.trim();
    
    if (text.isEmpty) {
      _clearSuggestions();
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set loading state immediately for better UX
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _showSuggestions = true;
      });
    }

    // Debounce for 300ms (reduced from 500ms for faster response)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _getSuggestions(text);
    });
  }

  Future<void> _getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      _clearSuggestions();
      return;
    }

    try {
      // First, check cache
      final cachedSuggestions = await WeatherCacheService.getCachedSearchSuggestions(query);
      
      if (cachedSuggestions != null) {
        setState(() {
          _suggestions = cachedSuggestions;
          _isLoading = false;
          _showSuggestions = true;
        });
        return;
      }

      // If not in cache, fetch from API
      final nominatimService = context.read<NominatimService>();
      final suggestions = await nominatimService.getAutocompleteSuggestions(query);

      // Cache the results
      if (suggestions.isNotEmpty) {
        await WeatherCacheService.cacheSearchSuggestions(query, suggestions);
      }

      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
          _showSuggestions = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuggestions = false;
        });
      }
    }
  }

  void _clearSuggestions() {
    setState(() {
      _suggestions.clear();
      _isLoading = false;
      _showSuggestions = false;
    });
  }

  void _onSuggestionSelected(dynamic suggestion) async {
    final weatherProvider = context.read<WeatherProvider>();
    
    try {
      double? latitude;
      double? longitude;
      String cityName = '';

      if (suggestion is Map<String, dynamic>) {
        // Nominatim suggestion
        latitude = suggestion['lat']?.toDouble();
        longitude = suggestion['lon']?.toDouble();
        cityName = suggestion['display_name']?.split(',')[0] ?? '';
      }

      if (latitude != null && longitude != null) {
        _controller.text = cityName;
        _clearSuggestions();
        _focusNode.unfocus();

        // Fetch weather data
        await weatherProvider.getWeatherByCoordinates(
          latitude: latitude,
          longitude: longitude,
          cityName: cityName,
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Input
        Container(
          decoration: BoxDecoration(
            color: ThemeConstants.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
            border: Border.all(
              color: ThemeConstants.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: ThemeConstants.bodyMedium.copyWith(
              color: ThemeConstants.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search city, country...',
              hintStyle: ThemeConstants.bodyMedium.copyWith(
                color: ThemeConstants.white.withOpacity(0.6),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: ThemeConstants.white.withOpacity(0.7),
                size: 20,
              ),
              suffixIcon: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ThemeConstants.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: ThemeConstants.white.withOpacity(0.7),
                            size: 20,
                          ),
                          onPressed: () {
                            _controller.clear();
                            _clearSuggestions();
                          },
                        )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spacingM,
                vertical: ThemeConstants.spacingS,
              ),
            ),
            onTap: () {
              if (_suggestions.isNotEmpty) {
                setState(() {
                  _showSuggestions = true;
                });
              }
            },
          ),
        ),

        // Suggestions List
        if (_showSuggestions && (_suggestions.isNotEmpty || _isLoading))
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: ThemeConstants.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      final displayName = suggestion['display_name'] ?? '';
                      final parts = displayName.split(',');
                      final cityName = parts.isNotEmpty ? parts[0].trim() : '';
                      final countryName = parts.length > 1 ? parts.last.trim() : '';

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.spacingM,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: ThemeConstants.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 16,
                            color: ThemeConstants.primaryBlue,
                          ),
                        ),
                        title: Text(
                          cityName,
                          style: ThemeConstants.bodyMedium.copyWith(
                            color: ThemeConstants.darkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          countryName,
                          style: ThemeConstants.bodySmall.copyWith(
                            color: ThemeConstants.darkBlue.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        onTap: () => _onSuggestionSelected(suggestion),
                      );
                    },
                  ),
          ),
      ],
    );
  }
} 