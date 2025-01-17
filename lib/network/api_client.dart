import 'dart:convert';

import 'package:dio/dio.dart' as DioApi;
import 'package:dio/dio.dart';
import 'package:weather_app/network/service_exception.dart';
import '../logger.dart';

class ApiClient {
  static late Dio _dio;

  static Future<void> init() async {
    _dio = Dio();
  }

  //get request
  static Future<dynamic> getRequest({
    required String endpoint,
    Options? options,
    Map<String, dynamic> query = const {},
  }) async {
    try {
      logger.d("REQUEST END POINT : $endpoint");
      DioApi.Response response =
          await _dio.get(endpoint, queryParameters: query, options: options);
      logger.e("DIO : : ${response.data.toString()}");
      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
                jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      logger.e("DIO : : ${e.response?.data.toString()}");
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
}
