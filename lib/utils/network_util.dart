import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';

class NetworkUtil {
  //单例
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  Future<dynamic> post(String url, Map body, bool encode) async {
    Dio dio = new Dio();

    try {
      Response response =
          await dio.post(url, data: encode == true ? jsonEncode(body) : body);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }

  Future<dynamic> get(String url, Map body) async {
    Dio dio = new Dio();

    try {
      Response response =
          await dio.get(url, data: body.length > 0 ? body : null);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }

  Future<dynamic> put(String url, Map body, bool encode) async {
    Dio dio = new Dio();

    try {
      Response response =
          await dio.put(url, data: encode == true ? jsonEncode(body) : body);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }

  Future<dynamic> delete(String url) async {
    Dio dio = new Dio();

    try {
      Response response = await dio.delete(url);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }

  Future<dynamic> patch(String url, Map body, bool encode) async {
    Dio dio = new Dio();

    try {
      Response response =
          await dio.patch(url, data: encode == true ? jsonEncode(body) : body);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }

  Future<dynamic> download(String url, String fileName) async {
    Dio dio = new Dio();

    try {
      Response response =
          await dio.download(url, fileName, onProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      });
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw new Exception(e.response.data);
      } else {
        throw new Exception(e.message);
      }
    }
  }
}
