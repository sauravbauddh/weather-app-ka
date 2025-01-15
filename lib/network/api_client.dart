import 'dart:convert';

import 'package:dio/dio.dart' as DioApi;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weather_app/network/refresh_token_request.dart';
import 'package:weather_app/network/service_exception.dart';
import 'package:weather_app/network/shared_prefs.dart';
import '../logger.dart';
import 'api_end_points.dart';

class ApiClient {
  static late Dio _dio;
  static String accessToken = '';
  static String appVersion = '';
  static String appId = 'com.sorted.consumerflutterapp';

  // static final LogInterceptor _logInterceptor = LogInterceptor(
  //   responseBody: false,
  //   requestHeader: false,
  //   responseHeader: false,
  //   request: false,
  //   error: false,
  //   requestBody: false,
  //   // logPrint: (obj) => logger.i(obj is Map ? jsonEncode(obj) : obj.toString()),
  // );

  static dynamic _requestInterceptor(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    String? storeId = await SharedPref.getStringWithKey("");
    request.headers['Authorization'] = accessToken;
    request.headers['appVersion'] = appVersion;
    request.headers['appId'] = appId;
    request.headers['storeid'] = storeId;
    return handler.next(request);
  }

  static Future<void> init() async {
    var option = BaseOptions(baseUrl: ApiEndPoints.baseUrl);
    _dio = Dio(option);
    accessToken = await SharedPref.getAccessToken() ?? '';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    _dio.options.headers['Authorization'] = accessToken;
    _dio.options.headers['appVersion'] = appVersion;
    _dio.options.headers['appId'] = appId;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) => _requestInterceptor(request, handler),
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            String? newToken = await refreshToken();
            if (newToken != null) {
              _dio.options.headers["Authorization"] = newToken;
              return handler.resolve(await _dio.fetch(e.requestOptions));
            }
          } else if (e.response?.statusCode == 469) {
            logout();
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
      ),
    );
  }

  static logout() {
    if (isRedundentClick(DateTime.now())) {
      return;
    }
    SharedPref.clearTokens();
    SharedPref.clearSharedPref();
    // Get.offAll(
    //   () => const SplashScreen(),
    // );
  }

  static DateTime? loginClickTime;

  static bool isRedundentClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
    if (currentTime.difference(loginClickTime!).inSeconds < 5) {
      // set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }

  //get request
  static Future<dynamic> getRequest({
    required String endpoint,
    Options? options,
    Map<String, dynamic> query = const {},
  }) async {
    try {
      // logger.d("REQUEST END POINT : $endpoint");
      DioApi.Response response =
          await _dio.get(endpoint, queryParameters: query, options: options);
      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      // logger.e("DIO : : ${e.response?.data.toString()}");
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //post request
  static Future<dynamic> postRequest({
    required endpoint,
    param = const {"": ""},
    Options? options,
  }) async {
    try {
      logger.d("--------------------");
      DioApi.Response response =
          await _dio.post(endpoint, data: param, options: options);
      return response;
    } on DioException catch (e) {
      logger.e("DIO : : ${e.response?.data}");
      // if (e.response?.statusMessage != "" &&
      //     e.response?.statusMessage != null) {
      //   throw ServiceException(message: e.response?.statusMessage.toString());
      // } else
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //put request
  static Future<dynamic> putRequest(
      {required endpoint,
      param = const {"": ""},
      id,
      Map<String, dynamic> headers = const {}}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : PUT ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      logger.d("REQUEST DATA : $param");
      DioApi.Response response;
      if (id == null) {
        response = await _dio.put(endpoint,
            data: param, options: Options(headers: headers));
      } else {
        response = await _dio.put(endpoint + "/" + id.toString(),
            data: param, options: Options(headers: headers));
      }

      return response;
    } on DioException catch (e) {
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //patch request
  static Future<dynamic> patchRequest(
      {required endpoint, param = const {"": ""}, id}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : PUT ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      logger.d("REQUEST DATA : $param");

      DioApi.Response response =
          await _dio.patch(endpoint + "/" + id.toString(), data: param);

      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //delete Request
  static Future<dynamic> deleteRequest({required endpoint, id}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : delete ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      DioApi.Response response;
      if (id == null) {
        response = await _dio.delete(endpoint);
      } else {
        response = await _dio.delete(endpoint + "/" + id.toString());
      }

      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  static DateTime? refreshTime;

  static Future<String?> refreshToken() async {
    if (isRedundentRefresh(DateTime.now())) {
      return '';
    }
    String refreshToken = await SharedPref.getRefreshToken() ?? '';
    logger.d("Refresh Token : $refreshToken");
    DioApi.Response response = await postRequest(
        endpoint: ApiEndPoints.refresh,
        param: RefreshTokenRequest(refreshToken: refreshToken).toJson());
    logger.d("response: ${response.data}");
    // var user = loginUserModelFromJson(jsonEncode(response.data));
    // SharedPref.setTokens(user.accessToken!, user.refreshToken!);
    // SharedPref.setCurrentUser(user.user!);
    await ApiClient.init();
    // return user.accessToken;
  }

  static bool isRedundentRefresh(DateTime currentTime) {
    if (refreshTime == null) {
      refreshTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(refreshTime!).inSeconds}');
    if (currentTime.difference(refreshTime!).inSeconds < 5) {
      // set this difference time in seconds
      return true;
    }

    refreshTime = currentTime;
    return false;
  }
}
