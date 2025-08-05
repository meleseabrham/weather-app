import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/theme_constants.dart';
import '../../data/services/nominatim_service.dart';
import 'package:dio/dio.dart';

class NominatimSearchBar extends StatefulWidget {
  final Function(String placeName, double latitude, double longitude) onPlaceSelected;
  final String hintText;

  const NominatimSearchBar({
    Key? key,
    required this.onPlaceSelected,
    this.hintText = 'Search for any city, town, or country...',
  }) : super(key: key);

  @override
  State<NominatimSearchBar> createState() => _NominatimSearchBarState();
}

class _NominatimSearchBarState extends State<NominatimSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final NominatimService _nominatimService;
  
  Timer? _debounceTimer;
  List<PlaceAutocompleteResult> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    // Initialize the service
    _nominatimService = NominatimService(Dio());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    print('📝 Text changed to: "${_controller.text}"');
    _debounceTimer?.cancel();
    
    if (_controller.text.trim().isEmpty) {
      print('🗑️ Text is empty, clearing suggestions');
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _isLoading = false;
      });
      return;
    }

    print('⏳ Setting loading state and showing suggestions');
    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    // Set new timer for debouncing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      print('⏰ Debounce timer fired, getting suggestions');
      _getSuggestions();
    });
  }

  Future<void> _getSuggestions() async {
    try {
      print('🔍 Calling Google Places service for suggestions');
      final suggestions = await _nominatimService.getAutocompleteSuggestions(_controller.text);
      
      print('📋 Received ${suggestions.length} suggestions');
      
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
        print('✅ Updated UI with suggestions');
      }
    } catch (e) {
      print('💥 Error in _getSuggestions: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSuggestionSelected(PlaceAutocompleteResult suggestion) async {
    try {
      print('📍 Place selected: ${suggestion.description}');
      
      // Check if we have coordinates directly from the suggestion
      if (suggestion.latitude != null && suggestion.longitude != null) {
        print('✅ Using coordinates directly from suggestion: ${suggestion.latitude}, ${suggestion.longitude}');
        
        _controller.text = suggestion.description;
        _focusNode.unfocus();
        
        setState(() {
          _showSuggestions = false;
        });

        // Call the callback with place name and coordinates
        widget.onPlaceSelected(
          suggestion.mainText.isNotEmpty ? suggestion.mainText : suggestion.description,
          suggestion.latitude!,
          suggestion.longitude!,
        );
      } else {
        print('❌ No coordinates in suggestion, trying to get place details');
        
        // Fallback: try to get place details (this should rarely happen now)
        final placeDetails = await _nominatimService.getPlaceDetails(suggestion.placeId);
        
        if (placeDetails != null && 
            placeDetails.latitude != null && 
            placeDetails.longitude != null) {
          
          _controller.text = suggestion.description;
          _focusNode.unfocus();
          
          setState(() {
            _showSuggestions = false;
          });

          // Call the callback with place name and coordinates
          widget.onPlaceSelected(
            placeDetails.name,
            placeDetails.latitude!,
            placeDetails.longitude!,
          );
        } else {
          print('❌ Could not get coordinates for selected place');
        }
      }
    } catch (e) {
      print('💥 Error getting place details: $e');
    }
  }

  void _onSearchSubmitted() async {
    if (_controller.text.trim().isNotEmpty) {
      try {
        print('🔍 Searching for: ${_controller.text}');
        
        // Search for places
        final places = await _nominatimService.searchPlaces(_controller.text);
        
        if (places.isNotEmpty && 
            places.first.latitude != null && 
            places.first.longitude != null) {
          
          print('✅ Found place via Nominatim: ${places.first.name}');
          _focusNode.unfocus();
          setState(() {
            _showSuggestions = false;
          });

          // Use the first result
          widget.onPlaceSelected(
            places.first.name,
            places.first.latitude!,
            places.first.longitude!,
          );
        } else {
          print('❌ No results found for: ${_controller.text}');
        }
      } catch (e) {
        print('💥 Error searching places: $e');
      }
    }
  }

  void _clearText() {
    _controller.clear();
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
      children: [
        // Search Bar
        Container(
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
              // Search Icon
              Padding(
                padding: const EdgeInsets.only(left: ThemeConstants.spacingM),
                child: Icon(
                  Icons.search,
                  color: ThemeConstants.white.withOpacity(0.7),
                  size: 20,
                ),
              ),
              
              // Text Field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: ThemeConstants.bodyMedium.copyWith(
                    color: ThemeConstants.white,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: ThemeConstants.bodyMedium.copyWith(
                      color: ThemeConstants.white.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spacingM,
                      vertical: ThemeConstants.spacingM,
                    ),
                  ),
                  onSubmitted: (_) => _onSearchSubmitted(),
                ),
              ),
              
              // Clear Button
              if (_controller.text.isNotEmpty)
                IconButton(
                  onPressed: _clearText,
                  icon: Icon(
                    Icons.clear,
                    color: ThemeConstants.white.withOpacity(0.7),
                    size: 20,
                  ),
                ),
              
              // Search Button
              IconButton(
                onPressed: _onSearchSubmitted,
                icon: Icon(
                  Icons.search,
                  color: ThemeConstants.white.withOpacity(0.7),
                  size: 20,
                ),
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
              constraints: const BoxConstraints(
                maxHeight: 200, // Reduced from 300 to prevent overflow
                minHeight: 50,
              ),
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
                                size: 24, // Reduced from 32
                              ),
                              const SizedBox(height: ThemeConstants.spacingS),
                              Text(
                                'No places found',
                                style: ThemeConstants.bodyMedium.copyWith(
                                  color: ThemeConstants.darkGrey.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: ThemeConstants.spacingXS),
                              Text(
                                'Try searching for a different location',
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
                          physics: const ClampingScrollPhysics(),
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = _suggestions[index];
                            return ListTile(
                              leading: Container(
                                width: 28, // Reduced from 32
                                height: 28, // Reduced from 32
                                decoration: BoxDecoration(
                                  color: ThemeConstants.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: ThemeConstants.primaryBlue,
                                  size: 16, // Reduced from 18
                                ),
                              ),
                              title: Text(
                                suggestion.mainText,
                                style: ThemeConstants.bodyMedium.copyWith(
                                  color: ThemeConstants.darkGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14, // Explicit font size
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                suggestion.secondaryText,
                                style: ThemeConstants.bodySmall.copyWith(
                                  color: ThemeConstants.darkGrey.withOpacity(0.7),
                                  fontSize: 12, // Explicit font size
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              onTap: () => _onSuggestionSelected(suggestion),
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: ThemeConstants.spacingM,
                                vertical: ThemeConstants.spacingXS,
                              ),
                            );
                          },
                        ),
            ),
          ),
      ],
    );
  }
} 