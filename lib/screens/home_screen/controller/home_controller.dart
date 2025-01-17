import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:weather_app/repo/weather_repo.dart';
import 'package:weather_app/screens/models/weather_response.dart';
import 'package:weather_app/widgets/tab_row.dart';

import '../../../core/appwrite_controller.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/location_service.dart';
import '../../models/forecase_response.dart';

class HomeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> isBannerLoading = false.obs;
  Rx<bool> isForecastLoading = false.obs;
  Rx<CurrentWeatherResponse> currentWeatherResponse =
      CurrentWeatherResponse().obs;
  Rx<ForecastResponse> forecastResponse = ForecastResponse().obs;
  RxList<String> citiesList = <String>[].obs;
  Rx<String> currentBannerId = "".obs;
  Rx<DocumentList?> bannerInfoList = Rx<DocumentList?>(null);
  Rx<String> lat = "".obs;
  Rx<String> lon = "".obs;

  final appWriteController = Get.find<AppWriteController>();
  final tabController = Get.find<TabRowController>();
  final locationService = Get.find<LocationService>();

  Future<void> getWeatherData(String? location) async {
    try {
      // print("LL ${lat.value} ${lon.value}");
      isLoading.value = true;
      isForecastLoading.value = true;
      tabController.selectedIndex.value = 0;
      final oldBannerId = currentBannerId.value;
      currentWeatherResponse.value = (await WeatherRepo.getCurrentWeatherData(
          location, lat.value, lon.value))!;
      if (bannerInfoList.value == null) {
        await getBannerInfo();
      }
      String? currentCondition =
          currentWeatherResponse.value.current?.condition?.text;
      if (currentCondition != null && bannerInfoList.value != null) {
        String generalizedCondition = getAssetAndCondition(currentCondition)[1];
        var matchingBanner = bannerInfoList.value?.documents.firstWhereOrNull(
          (doc) => doc.data['name'] == generalizedCondition,
        );
        if (matchingBanner != null) {
          currentBannerId.value = matchingBanner.data['s_id'] as String;
        } else {
          currentBannerId.value = oldBannerId.isNotEmpty ? oldBannerId : '';
        }
      } else {
        currentBannerId.value = oldBannerId.isNotEmpty ? oldBannerId : '';
      }
      // print("CurrentBanner: ${currentBannerId.value}");
    } catch (e) {
      // print("Error in getWeatherData: $e");
      if (currentBannerId.value.isEmpty && bannerInfoList.value != null) {
        var defaultBanner = bannerInfoList.value?.documents.firstOrNull;
        if (defaultBanner != null) {
          currentBannerId.value = defaultBanner.data['s_id'] as String;
        }
      }
    } finally {
      isLoading.value = false;
      isForecastLoading.value = false;
    }
  }

  String getValidBannerId() {
    if (currentBannerId.value.isEmpty && bannerInfoList.value != null) {
      String? defaultCondition =
          currentWeatherResponse.value.current?.condition?.text;
      if (defaultCondition != null) {
        String generalizedCondition = getAssetAndCondition(defaultCondition)[1];
        var matchingBanner = bannerInfoList.value?.documents.firstWhereOrNull(
          (doc) => doc.data['name'] == generalizedCondition,
        );
        if (matchingBanner != null) {
          currentBannerId.value = matchingBanner.data['s_id'] as String;
        }
      }
    }
    return currentBannerId.value;
  }

  Future<void> getForecastData({required int days, location}) async {
    isForecastLoading.value = true;
    forecastResponse.value = (await WeatherRepo.getForecastData(
        days: days, location: location, lat: lat.value, long: lon.value))!;
    isForecastLoading.value = false;
  }

  Future<void> useCurrentLocation() async {
    isLoading.value = true;
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      lat.value = position.latitude.toString();
      lon.value = position.longitude.toString();
      // print('Lat: ${position.latitude}, Long: ${position.longitude}');
    }
    isLoading.value = false;
    return;
  }

  getBannerInfo() async {
    isBannerLoading.value = true;
    bannerInfoList.value = await appWriteController.getBannerInfo();
    isBannerLoading.value = false;
  }
}
