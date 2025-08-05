import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/theme_constants.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ThemeConstants.white.withOpacity(0.1),
      highlightColor: ThemeConstants.white.withOpacity(0.3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConstants.spacingL),
        child: Column(
          children: [
            // Header loading
            _buildHeaderLoading(),
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Temperature loading
            _buildTemperatureLoading(),
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Details loading
            _buildDetailsLoading(),
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Forecast loading
            _buildForecastLoading(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLoading() {
    return Column(
      children: [
        Container(
          height: 32,
          width: 200,
          decoration: BoxDecoration(
            color: ThemeConstants.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
          ),
        ),
        const SizedBox(height: ThemeConstants.spacingS),
        Container(
          height: 16,
          width: 150,
          decoration: BoxDecoration(
            color: ThemeConstants.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
          ),
        ),
        const SizedBox(height: ThemeConstants.spacingS),
        Container(
          height: 14,
          width: 120,
          decoration: BoxDecoration(
            color: ThemeConstants.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: ThemeConstants.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXL),
          ),
        ),
        const SizedBox(width: ThemeConstants.spacingL),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 80,
              decoration: BoxDecoration(
                color: ThemeConstants.white,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              ),
            ),
            const SizedBox(height: ThemeConstants.spacingS),
            Container(
              height: 16,
              width: 100,
              decoration: BoxDecoration(
                color: ThemeConstants.white,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsLoading() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingL),
      decoration: BoxDecoration(
        color: ThemeConstants.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 150,
            decoration: BoxDecoration(
              color: ThemeConstants.darkGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
            ),
          ),
          const SizedBox(height: ThemeConstants.spacingL),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: ThemeConstants.spacingM,
            mainAxisSpacing: ThemeConstants.spacingM,
            childAspectRatio: 2.5,
            children: List.generate(6, (index) => Container(
              decoration: BoxDecoration(
                color: ThemeConstants.darkGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastLoading() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingL),
      decoration: BoxDecoration(
        color: ThemeConstants.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 120,
            decoration: BoxDecoration(
              color: ThemeConstants.darkGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
            ),
          ),
          const SizedBox(height: ThemeConstants.spacingL),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Container(
                width: 100,
                margin: const EdgeInsets.only(right: ThemeConstants.spacingM),
                decoration: BoxDecoration(
                  color: ThemeConstants.darkGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 