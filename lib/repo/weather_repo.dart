import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_app/network/api_client.dart';
import 'package:weather_app/network/api_end_points.dart';
import 'package:weather_app/screens/models/forecase_response.dart';
import 'package:weather_app/screens/models/weather_response.dart';

import '../logger.dart';
import '../network/service_exception.dart';

class WeatherRepo {
  static Future<CurrentWeatherResponse?> getCurrentWeatherData(
      String? location, String lat, String long) async {
    try {
      Response response = await ApiClient.getRequest(
        endpoint: ApiEndPoints.getCurrentWeatherData,
        query: {
          "key": "20576d6664c647698d470010251501",
          "aqi": "yes",
          "q": location ?? "$lat,$long",
        },
      );
      if (response.statusCode == 200) {
        logger.d("getWeatherData : ${response.data}");
        var json = jsonEncode(response.data);
        return currentWeatherResponseFromJson(json);
      } else {
        logger.d("getWeatherData is null : ${response.data}");
      }
    } on ServiceException catch (e) {
      throw RepoServiceException(message: e.message);
    }
    return null;
  }

  static Future<ForecastResponse?> getForecastData(
      {required int days, String? location, String? lat, String? long}) async {
    try {
      Response response = await ApiClient.getRequest(
        endpoint: ApiEndPoints.getForecastData,
        query: {
          "key": "20576d6664c647698d470010251501",
          "days": days.toString(),
          "q": location ?? "$lat,$long",
        },
      );
      if (response.statusCode == 200) {
        logger.d("getWeatherData : ${response.data}");
        var json = jsonEncode(response.data);
        return forecastResponseFromJson(json);
      } else {
        logger.d("getWeatherData is null : ${response.data}");
      }
    } on ServiceException catch (e) {
      throw RepoServiceException(message: e.message);
    }
    return null;
  }
}
