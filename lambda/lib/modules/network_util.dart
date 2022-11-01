import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:get/get.dart';

BaseOptions options = new BaseOptions(
  headers: {
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8"
  },
  connectTimeout: 100000,
  receiveTimeout: 100000,
);

class NetworkUtil extends GetxController {
  static NetworkUtil instance = Get.find();

  final storage = new secure.FlutterSecureStorage();

  Dio dio = new Dio(options);

  initNetwork(baseUrl) {
    options.baseUrl = baseUrl;
  }

  handleError(DioError e) {
    print(e.message);

    //GLOBAL ERROR HANDLER will be here
  }

  Future<dynamic> get(String url, {dynamic params, String? base}) async {
    if (base != null) {
      options.baseUrl = base;
    }

    try {
      String jwt = await storage.read(key: 'jwt') ?? "";
      if (jwt != "") {
        dio.interceptors.add(
          InterceptorsWrapper(onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers["Authorization"] = "Bearer $jwt";
            return handler.next(options); //continue
          }),
        );
      }

      var response = await dio.get(
        url,
        queryParameters: params ??
            null, /*options: buildCacheOptions(Duration(days: 7), forceRefresh: true),*/
      );

      return response.data;
    } on DioError catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<dynamic> post(String url, body, {String? base}) async {
    if (base != null) {
      options.baseUrl = base;
    }

    try {
      String jwt = await storage.read(key: 'jwt') ?? "";
      if (jwt != "") {
        dio.interceptors.add(
          InterceptorsWrapper(onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers["Authorization"] = "Bearer $jwt";
            return handler.next(options); //continue
          }),
        );
      }
      var response = await dio.post(url, data: body);

      return response.data;
    } on DioError catch (e) {
      handleError(e);

      if (e.response != null) {
        return e.response!.data;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<dynamic> get_(String url, {String? base}) async {
    if (base != null) {
      options.baseUrl = base;
    }
    try {
      String jwt = await storage.read(key: 'jwt') ?? "";

      if (jwt != "") {
        dio.interceptors.add(
          InterceptorsWrapper(onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers["Authorization"] = "Bearer $jwt";

            return handler.next(options); //continue
          }),
        );
      }

      var response = await dio.get(
        url, /*options: buildCacheOptions(Duration(days: 7), forceRefresh: true),*/
      );

      return response.data;
    } on DioError catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<dynamic> post_(String url, body,
      {String? base, bool cache: true}) async {
    if (base != null) {
      options.baseUrl = base;
    }

    try {
      String jwt = await storage.read(key: 'jwt') ?? "";
      if (jwt != "") {
        print("Bearer $jwt");
        dio.interceptors.add(
          InterceptorsWrapper(onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers["Authorization"] = "Bearer $jwt";
            options.headers["content-type"] = "application/json; charset=UTF-8";

            return handler.next(options); //continue
          }),
        );
      }
      if (cache) {
        var response = await dio.post(
          url,
          data:
              body, /*options: buildCacheOptions(Duration(days: 7), forceRefresh: true)*/
        );

        return response.data;
      } else {
        var response = await dio.post(
          url,
          data:
              body, /*options: buildCacheOptions(Duration(days: 0), forceRefresh: true)*/
        );

        return response.data;
      }
    } on DioError catch (e) {
      handleError(e);
      return e;
    }
    return null;
  }
}
