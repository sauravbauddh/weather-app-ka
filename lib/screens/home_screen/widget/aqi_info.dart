import 'package:flutter/material.dart';
import 'package:weather_app/core/text_styling.dart';
import 'package:weather_app/screens/models/weather_response.dart';

class AQIInfo extends StatefulWidget {
  final AirQuality airQualityData;
  final String location;
  final String lastUpdated;
  final bool isLoading;

  const AQIInfo({
    super.key,
    required this.airQualityData,
    required this.location,
    required this.lastUpdated,
    required this.isLoading,
  });

  @override
  State<AQIInfo> createState() => _AQIInfoState();
}

class _AQIInfoState extends State<AQIInfo> with SingleTickerProviderStateMixin {
  late final aqiValue;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    aqiValue = widget.airQualityData.gbDefraIndex ?? 0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getAqiCategory(int value) {
    if (value <= 50) return "Good";
    if (value <= 100) return "Moderate";
    if (value <= 150) return "Unhealthy for Sensitive Groups";
    if (value <= 200) return "Unhealthy";
    if (value <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  Color getAqiColor(int value) {
    if (value <= 50) return Colors.green.shade400;
    if (value <= 100) return Colors.yellow.shade700;
    if (value <= 150) return Colors.orange.shade400;
    if (value <= 200) return Colors.red.shade400;
    if (value <= 300) return Colors.purple.shade400;
    return Colors.brown.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final String category = getAqiCategory(aqiValue);
    final Color aqiColor = getAqiColor(aqiValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isLoading) {
      return _buildLoadingState(isDark);
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    aqiColor.withOpacity(0.3),
                    aqiColor.withOpacity(0.1),
                  ]
                : [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: aqiColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: aqiColor.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(aqiColor, isDark),
            const SizedBox(height: 24),
            _buildAqiDisplay(aqiColor, category, isDark),
            const SizedBox(height: 24),
            _buildPollutantsSection(isDark),
            const SizedBox(height: 24),
            _buildHealthTip(aqiColor, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading air quality data...',
            style: gStyle(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color aqiColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Air Quality Index",
          style: gStyle(
            size: 24,
            weight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: aqiColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.air,
            color: aqiColor,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildAqiDisplay(Color aqiColor, String category, bool isDark) {
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0, end: aqiValue.toDouble()),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    aqiColor.withOpacity(0.7),
                    aqiColor,
                  ],
                  center: Alignment.center,
                  radius: 0.8,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: aqiColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${value.toInt()}",
                  style: gStyle(
                    size: 32,
                    weight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: gStyle(
                  color: aqiColor,
                  size: 22,
                  weight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.location,
                style: gStyle(
                  size: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Updated: ${widget.lastUpdated}",
                style: gStyle(
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPollutantsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pollutant Levels",
          style: gStyle(
            size: 18,
            weight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildPollutantTile("CO", widget.airQualityData.co, isDark),
            _buildPollutantTile("NO₂", widget.airQualityData.no2, isDark),
            _buildPollutantTile("O₃", widget.airQualityData.o3, isDark),
            _buildPollutantTile("SO₂", widget.airQualityData.so2, isDark),
            _buildPollutantTile("PM2.5", widget.airQualityData.pm25, isDark),
            _buildPollutantTile("PM10", widget.airQualityData.pm10, isDark),
          ],
        )
      ],
    );
  }

  Widget _buildPollutantTile(String name, double? value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: gStyle(
              size: 14,
              weight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toStringAsFixed(1) ?? "N/A",
            style: gStyle(
              size: 13,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTip(Color aqiColor, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? aqiColor.withOpacity(0.2) : aqiColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: aqiColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: aqiColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.health_and_safety,
              color: aqiColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getHealthTip(aqiValue),
              style: gStyle(
                size: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHealthTip(int value) {
    if (value <= 50) {
      return "Air quality is ideal for outdoor activities.";
    } else if (value <= 100) {
      return "Unusually sensitive people should consider reducing prolonged outdoor activities.";
    } else if (value <= 150) {
      return "People with respiratory issues should limit outdoor exposure.";
    } else if (value <= 200) {
      return "Everyone should reduce outdoor activities. Stay indoors when possible.";
    } else if (value <= 300) {
      return "Avoid all outdoor physical activities. Stay indoors.";
    }
    return "Health alert: Everyone should avoid all outdoor activities.";
  }
}
