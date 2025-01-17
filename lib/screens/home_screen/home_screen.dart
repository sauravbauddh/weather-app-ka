import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/text_styling.dart';
import 'package:weather_app/screens/home_screen/widget/aqi_info.dart';
import 'package:weather_app/screens/home_screen/widget/city_info_section.dart';
import 'package:weather_app/screens/home_screen/widget/day_wise_temperature.dart';
import 'package:weather_app/screens/home_screen/widget/other_info.dart';
import 'package:weather_app/screens/home_screen/widget/shimmer.dart';
import 'package:weather_app/screens/home_screen/widget/temperature_info_section.dart';
import '../../core/appwrite_controller.dart';
import '../../core/helpers/helpers.dart';
import '../../core/theme_controller.dart';
import '../../network/storage_service.dart';
import '../models/weather_response.dart';
import '../select_city/select_search.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();
  final AppWriteController appWriteController = Get.find<AppWriteController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fetchData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _fetchData() async {
    final storageService = Get.find<StorageService>();
    final lastCity = storageService.getLastCity();
    await controller.useCurrentLocation();
    controller.getWeatherData(lastCity);
    controller.getForecastData(days: 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Obx(
      () => controller.isLoading.value || controller.isBannerLoading.value
          ? const Scaffold(body: WeatherShimmerLoading())
          : Scaffold(
              body: FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeaderSection(screenHeight, screenWidth),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildInfoSections(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _onRefresh() async {
    _fetchData();
  }

  Widget _buildHeaderSection(double screenHeight, double screenWidth) {
    return Stack(
      children: [
        Container(
          height: screenHeight * 0.52,
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildBackgroundImage(screenHeight, screenWidth),
              _buildOverlayGradient(),
              _buildHeaderContent(screenHeight, screenWidth),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: CitySearchWidget(
            isLoading: controller.isLoading.value,
            onCitySelected: (String city) {
              controller.getWeatherData(city);
              controller.getForecastData(days: 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(double screenHeight, double screenWidth) {
    if (controller.isBannerLoading.value ||
        controller.currentBannerId.value.isEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: Image.asset(
          getAssetAndCondition(controller
                      .currentWeatherResponse.value.current?.condition?.text ??
                  "default")
              .first,
          width: screenWidth,
          height: screenHeight * 0.53,
          fit: BoxFit.cover,
        ),
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: FadeInImage.assetNetwork(
        width: screenWidth,
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 500),
        fit: BoxFit.cover,
        height: screenHeight * 0.53,
        placeholder: getAssetAndCondition(controller
                    .currentWeatherResponse.value.current?.condition?.text ??
                "default")
            .first,
        image: appWriteController.getFileUrl(controller.getValidBannerId()),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            getAssetAndCondition(controller.currentWeatherResponse.value.current
                        ?.condition?.text ??
                    "default")
                .first,
            width: screenWidth,
            height: screenHeight * 0.35,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildOverlayGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(double screenHeight, double screenWidth) {
    return Positioned(
      top: screenHeight * 0.15,
      left: screenWidth * 0.04,
      right: screenWidth * 0.04,
      child: Column(
        children: [
          CityInfo(
            isLoading: controller.isLoading.value,
            localTime:
                controller.currentWeatherResponse.value.location?.localtime,
            name: controller.currentWeatherResponse.value.location?.name,
            country: controller.currentWeatherResponse.value.location?.country,
            region: controller.currentWeatherResponse.value.location?.region,
          ),
          const SizedBox(height: 16),
          TemperatureInfo(
            isLoading: controller.isLoading.value,
            temp: controller.currentWeatherResponse.value.current?.tempC
                    ?.toString() ??
                " ",
            weatherCondition: controller
                    .currentWeatherResponse.value.current?.condition?.text ??
                "",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSections() {
    return Column(
      children: [
        OtherInfo(
          isLoading: controller.isLoading.value,
          windSpeed: controller.currentWeatherResponse.value.current?.windKph
              ?.toString(),
          humidity: controller.currentWeatherResponse.value.current?.humidity
              ?.toString(),
          cloudiness: controller.currentWeatherResponse.value.current?.cloud
              ?.toString(),
        ),
        const SizedBox(height: 16),
        _buildForecastSection(),
        const SizedBox(height: 16),
        _buildAQISection(),
        const SizedBox(height: 24),
        _buildCreditsSection(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildForecastSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeController.isDarkMode.value
              ? [
                  Colors.grey[900]!.withOpacity(0.9),
                  Colors.grey[850]!.withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.grey[50]!.withOpacity(0.9),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: themeController.isDarkMode.value
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: DayWiseTemperature(
          isLoading: controller.isLoading.value,
          forecast: controller.forecastResponse.value.forecast,
        ),
      ),
    );
  }

  Widget _buildAQISection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeController.isDarkMode.value
              ? [
                  Colors.grey[900]!.withOpacity(0.9),
                  Colors.grey[850]!.withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.grey[50]!.withOpacity(0.9),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: themeController.isDarkMode.value
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AQIInfo(
          isLoading: controller.isLoading.value,
          airQualityData:
              controller.currentWeatherResponse.value.current?.airQuality ??
                  AirQuality(),
          location:
              controller.currentWeatherResponse.value.location?.name ?? '',
          lastUpdated:
              controller.currentWeatherResponse.value.current?.lastUpdated ??
                  '',
        ),
      ),
    );
  }

  Widget _buildCreditsSection() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController.isDarkMode.value
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.grey[200]!, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeController.isDarkMode.value
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rocket_launch,
                  size: 18,
                  color: themeController.isDarkMode.value
                      ? Colors.blue[300]
                      : Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Rushed 😛 and speed-coded 🥴 by',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[300]
                        : Colors.grey[700],
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Saurav Bauddh',
                    style: gStyle(
                      color: themeController.isDarkMode.value
                          ? Colors.blue[300]
                          : Colors.blue[700],
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'With a little help from...',
              style: gStyle(
                color: themeController.isDarkMode.value
                    ? Colors.grey[400]
                    : Colors.grey[600],
                size: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.psychology,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.purple[300]
                      : Colors.purple[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Claude',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.purple[300]
                        : Colors.purple[700],
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' 🤫',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '&',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ChatGPT',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.green[300]
                        : Colors.green[700],
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' 😁',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.terminal,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.orange[300]
                      : Colors.orange[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'StackOverflow',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.orange[300]
                        : Colors.orange[700],
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' (the lifesaver)',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.blue[300]
                      : Colors.blue[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Flutter Docs',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.blue[300]
                        : Colors.blue[700],
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' (the teacher)',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.red[300]
                      : Colors.red[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'YouTube Tutorials',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.red[300]
                        : Colors.red[700],
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' (the explainer)',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bedtime,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.indigo[300]
                      : Colors.indigo[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Fueled by',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '2 sleepless nights',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.indigo[300]
                        : Colors.indigo[700],
                    size: 13,
                    fontStyle: FontStyle.italic,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.nightlight_round,
                  size: 14,
                  color: themeController.isDarkMode.value
                      ? Colors.indigo[300]
                      : Colors.indigo[700],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.coffee,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.brown[300]
                      : Colors.brown[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Powered by',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'countless cups of coffee',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.brown[300]
                        : Colors.brown[700],
                    size: 13,
                    fontStyle: FontStyle.italic,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flutter_dash,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.lightBlue[300]
                      : Colors.lightBlue[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Built with Flutter',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '& lots of',
                  style: gStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    size: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.favorite,
                  size: 14,
                  color: themeController.isDarkMode.value
                      ? Colors.red[300]
                      : Colors.red[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
