import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class UnitToggle extends StatelessWidget {
  final String currentUnit;
  final Function(String) onUnitChanged;

  const UnitToggle({
    Key? key,
    required this.currentUnit,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConstants.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUnitButton('metric', '°C', currentUnit == 'metric'),
          _buildUnitButton('imperial', '°F', currentUnit == 'imperial'),
        ],
      ),
    );
  }

  Widget _buildUnitButton(String unit, String symbol, bool isSelected) {
    return GestureDetector(
      onTap: () => onUnitChanged(unit),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingM, // Increased from spacingS to spacingM
          vertical: ThemeConstants.spacingS, // Increased from spacingXS to spacingS
        ),
        decoration: BoxDecoration(
          color: isSelected ? ThemeConstants.white : Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
        ),
        child: Text(
          symbol,
          style: ThemeConstants.bodyMedium.copyWith( // Changed from bodySmall to bodyMedium
            color: isSelected ? ThemeConstants.darkGrey : ThemeConstants.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16, // Added explicit fontSize for better control
          ),
        ),
      ),
    );
  }
} 