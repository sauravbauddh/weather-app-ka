class ApiEndPoints {
  ApiEndPoints._();

  static bool isInitialised = false;

  static String baseUrl = 'http://api.weatherapi.com/v1/';
  static String getCurrentWeatherData = "${baseUrl}current.json";
  static String getForecastData = "${baseUrl}forecast.json";
  static String appWriteBaseUrl = 'https://cloud.appwrite.io/v1';
}
