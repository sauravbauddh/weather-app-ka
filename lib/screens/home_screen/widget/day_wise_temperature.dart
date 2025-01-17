import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/text_styling.dart';
import '../../../core/theme_controller.dart';
import '../../../widgets/tab_row.dart';
import '../../models/forecase_response.dart';
import '../controller/home_controller.dart';

class DayWiseTemperature extends StatefulWidget {
  final Forecast? forecast;
  final bool isLoading;

  const DayWiseTemperature(
      {required this.forecast, super.key, required this.isLoading});

  @override
  State<DayWiseTemperature> createState() => _DayWiseTemperatureState();
}

class _DayWiseTemperatureState extends State<DayWiseTemperature> {
  final tabRowController = Get.find<TabRowController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode.value;
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: isDark ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: Get.width,
            height: Get.height * 0.28,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.blue.shade900, Colors.indigo.shade900]
                    : [Colors.blue.shade50, Colors.indigo.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.blue.shade800 : Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabRow(),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() => homeController.isForecastLoading.value
                      ? _buildLoadingAnimation(isDark)
                      : _buildWeatherList(isDark)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingAnimation(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.white : Colors.blue,
              ),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Updating forecast...',
            style: gStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherList(bool isDark) {
    if (widget.forecast == null) {
      return Center(
        child: Text(
          'No forecast data available',
          style: gStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            size: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: tabRowController.selectedIndex.value == 0
          ? widget.forecast?.forecastday?.first.hour?.length
          : widget.forecast?.forecastday?[1].hour?.length ?? 0,
      itemBuilder: (context, index) {
        var hourData = tabRowController.selectedIndex.value == 0
            ? widget.forecast?.forecastday?.first.hour![index]
            : widget.forecast?.forecastday?[1].hour![index];
        if (hourData == null) return const SizedBox.shrink();

        return Container(
          width: 85,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                ),
                child: Image.network(
                  "https:${hourData.condition?.icon}",
                  width: 35,
                  height: 35,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      color: isDark ? Colors.redAccent : Colors.red,
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hourData.time?.split(" ").last ?? "N/A",
                style: gStyle(
                  size: 14,
                  weight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${hourData.tempC}°C",
                style: gStyle(
                  size: 16,
                  weight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
