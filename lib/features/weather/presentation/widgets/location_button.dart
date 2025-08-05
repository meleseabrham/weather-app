import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LocationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.spacingM), // Increased from spacingS to spacingM
        decoration: BoxDecoration(
          color: ThemeConstants.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
        ),
        child: Icon(
          Icons.my_location,
          color: ThemeConstants.white,
          size: 28, // Increased from 20 to 28
        ),
      ),
    );
  }
} 