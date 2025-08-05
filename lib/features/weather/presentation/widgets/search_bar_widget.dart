import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConstants.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
        border: Border.all(
          color: ThemeConstants.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(
          color: ThemeConstants.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search for a city...',
          hintStyle: TextStyle(
            color: ThemeConstants.white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: ThemeConstants.white.withOpacity(0.7),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: ThemeConstants.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          print('Search button pressed: ${_controller.text.trim()}'); // Debug log
                          widget.onSearch(_controller.text.trim());
                          _focusNode.unfocus();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: ThemeConstants.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                    ),
                  ],
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: ThemeConstants.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      widget.onSearch(_controller.text.trim());
                      _focusNode.unfocus();
                    }
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingM,
            vertical: ThemeConstants.spacingM,
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            print('Search submitted: ${value.trim()}'); // Debug log
            widget.onSearch(value.trim());
            _focusNode.unfocus();
          }
        },
        onChanged: (value) {
          setState(() {});
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }
} 