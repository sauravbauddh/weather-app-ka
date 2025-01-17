import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../../core/text_styling.dart';

class TemperatureInfo extends StatelessWidget {
  final String temp;
  final String weatherCondition;
  final bool isLoading;

  const TemperatureInfo({
    super.key,
    required this.temp,
    required this.weatherCondition,
    required this.isLoading,
  });

  IconData _getWeatherIcon() {
    final condition = weatherCondition.toLowerCase();
    if (condition.contains('rain')) return WeatherIcons.rain;
    if (condition.contains('cloud')) return WeatherIcons.cloudy;
    if (condition.contains('snow')) return WeatherIcons.snow;
    if (condition.contains('thunder')) return WeatherIcons.thunderstorm;
    if (condition.contains('fog') || condition.contains('mist'))
      return WeatherIcons.fog;
    return WeatherIcons.day_sunny;
  }

  Color _getWeatherIconColor(BuildContext context, String condition) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    condition = condition.toLowerCase();
    if (condition.contains('rain')) {
      return isDark ? Colors.blue[300]! : Colors.blue[700]!;
    }
    if (condition.contains('cloud')) {
      return isDark ? Colors.grey[400]! : Colors.grey[600]!;
    }
    if (condition.contains('snow')) {
      return isDark ? Colors.lightBlue[200]! : Colors.lightBlue[700]!;
    }
    if (condition.contains('thunder')) {
      return isDark ? Colors.yellow[600]! : Colors.amber[700]!;
    }
    if (condition.contains('fog') || condition.contains('mist')) {
      return isDark ? Colors.grey[300]! : Colors.grey[500]!;
    }
    return isDark ? Colors.amber[400]! : Colors.orange[700]!;
  }

  Color _getContainerColor(BuildContext context, String condition) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    condition = condition.toLowerCase();

    if (condition.contains('rain')) {
      return isDark
          ? Colors.blue.withOpacity(0.2)
          : Colors.blue.withOpacity(0.1);
    }
    if (condition.contains('cloud')) {
      return isDark
          ? Colors.grey.withOpacity(0.2)
          : Colors.grey.withOpacity(0.1);
    }
    if (condition.contains('snow')) {
      return isDark
          ? Colors.lightBlue.withOpacity(0.2)
          : Colors.lightBlue.withOpacity(0.1);
    }
    if (condition.contains('thunder')) {
      return isDark
          ? Colors.yellow.withOpacity(0.2)
          : Colors.amber.withOpacity(0.1);
    }
    if (condition.contains('fog') || condition.contains('mist')) {
      return isDark
          ? Colors.grey.withOpacity(0.2)
          : Colors.grey.withOpacity(0.1);
    }
    // Sunny
    return isDark
        ? Colors.amber.withOpacity(0.2)
        : Colors.orange.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$temp°C",
              style: gStyle(
                size: 64,
                weight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            Text(
              weatherCondition,
              style: gStyle(
                size: 26,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: Get.width * 0.25,
          height: Get.width * 0.25,
          decoration: BoxDecoration(
            color: _getContainerColor(context, weatherCondition),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getWeatherIcon(),
            size: Get.width * 0.15,
            color: _getWeatherIconColor(context, weatherCondition),
          ),
        ),
      ],
    );
  }
}
